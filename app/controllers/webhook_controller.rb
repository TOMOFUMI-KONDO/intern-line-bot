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
          action, lender_name, content = event.message['text'].split(/[\s　]+/)

          begin
            response =
              if action == "借りた"
                Lending.create!(borrower_id: borrower_id, lender_name: lender_name, content: content)

                lending_count = Lending.where(borrower_id: borrower_id, lender_name: lender_name).count
                "#{lender_name}さんに#{content}を借りました！\n#{lender_name}さんには計#{lending_count}個の借りがあります。"

              elsif messages[0] == "一覧" && messages.length == 1
                lendings_per_lender = Lending
                                        .where("borrower_id = ?", user_id)
                                        .group(:lender_name, :content)
                                        .select("lender_name, content, count(*)")
                                        .each_with_object({}) do |lending, hash|
                  lender = lending.lender_name.intern
                  content = lending.content.intern
                  count = lending.count

                  if hash.key?(lender)
                    hash[lender][content] = count
                  else
                    hash[lender] = { content => count }
                  end
                end

                lendings_per_lender.map do |lender, content_counts|
                  count_total = content_counts.inject(0) do |result, content_count|
                    result + content_count[1]
                  end
                  count_per_content = content_counts.map do |content, count|
                    "- #{content}　#{count}個"
                  end
                  ["#{lender}　#{count_total}個", *count_per_content].join("\n")
                end.join("\n\n")

              elsif action == "返した"
                "#{lender_name}さんに#{content}を返しました！"

              else
                raise ArgumentError, "Unexpected action: #{action}"
              end

            client.reply_message(reply_token, { type: 'text', text: response })
          rescue => error
            logger.error error

            response = error.is_a?(ArgumentError) ?
                         "エラーが発生しました。入力値が間違っている可能性があります。" :
                         " 予期せぬエラーが発生しました。"
            client.reply_message(reply_token, { type: 'text', text: response })
          end
        else
          client.reply_message(reply_token, { type: 'text', text: 'そのメッセージ形式はサポートされていません' })
        end
      end
    end

    head :ok
  end
end
