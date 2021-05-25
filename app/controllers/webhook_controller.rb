require 'line/bot'

class WebhookController < ApplicationController
  protect_from_forgery except: [:callback] # CSRF対策無効化

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    end
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head 470
    end

    events = client.parse_events_from(body)
    events.each do |event|
      reply_token = event['replyToken']
      borrower_id = event['source']['userId']

      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          begin
            messages = event.message['text'].split(/[\s　]+/)

            response =
              if messages[0] == "借りた" && messages.length == 3
                lender_name = messages[1]
                content = messages[2]

                Lending.create!(borrower_id: borrower_id, lender_name: lender_name, content: content)

                count_lendings = Lending.where(borrower_id: borrower_id, lender_name: lender_name).count
                "#{lender_name}さんに#{content}を借りました！\n#{lender_name}さんには計#{count_lendings}個の借りがあります。"

              elsif messages[0] == "一覧" && messages.length == 1
                '佐藤くん(2個)　100円　マスタリングTCP/IP借りた、田中くん(1個)　研究の調査を手伝ってもらった、......'

              elsif messages[0] == "返した" && messages.length == 3
                "#{messages[2]}さんに#{messages[1]}を返しました！"

              else
                raise RuntimeError
              end

            client.reply_message(reply_token, { type: 'text', text: response })
          rescue => e
            puts e
            client.reply_message(
              reply_token,
              { type: 'text', text: "エラーが発生しました。入力値が間違っている可能性があります。" }
            )
          end
        else
          client.reply_message(reply_token, { type: 'text', text: 'そのメッセージ形式はサポートされていません' })
        end
      end
    end

    head :ok
  end
end
