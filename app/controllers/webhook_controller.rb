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
            action, lender_name, content = event.message['text'].split(/[\s　]+/)

            response =
              if action == "借りた"
                Lending.create!(borrower_id: borrower_id, lender_name: lender_name, content: content)

                lending_count = Lending.where(borrower_id: borrower_id, lender_name: lender_name).count
                "#{lender_name}さんに#{content}を借りました！\n#{lender_name}さんには計#{lending_count}個の借りがあります。"

              elsif action == "一覧"
                '佐藤くん(2個)　100円　マスタリングTCP/IP借りた、田中くん(1個)　研究の調査を手伝ってもらった、......'

              elsif action == "返した"
                "#{lender_name}さんに#{content}を返しました！"

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
