class WebhookController < ApplicationController
  protect_from_forgery except: [:callback] # CSRF対策無効化

  def client
    @client ||= LineBotClient.generate
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
              if action == "借りた" && lender_name && content
                Lending.create!(borrower_id: borrower_id, lender_name: lender_name, content: content)

                lending_count = Lending.not_returned.where(borrower_id: borrower_id, lender_name: lender_name).count
                "#{lender_name}さんに#{content}を借りました！\n#{lender_name}さんには計#{lending_count}個の借りがあります。"

              elsif action == "一覧"
                if lender_name
                  render_to_string partial: 'list_per_content', locals: {
                    lender_name: lender_name,
                    per_content_counts: Lending.not_returned
                                               .where(borrower_id: borrower_id, lender_name: lender_name)
                                               .count_per_content
                  }

                else
                  per_lender_content_counts = Lending.not_returned.where(borrower_id: borrower_id).count_per_lender_content
                  lendings_per_lender_content = Lending.format_per_lender_content_count(per_lender_content_counts)
                  render_to_string partial: 'list_per_lender', locals: { lendings_per_lender_content: lendings_per_lender_content }
                end

              elsif action == "返した" && lender_name && content
                lending = Lending.not_returned.find_by!(borrower_id: borrower_id, lender_name: lender_name, content: content)
                lending.return_content!

                lending_count = Lending.not_returned.where(borrower_id: borrower_id, lender_name: lender_name).count
                thanking = Thanking.random_choice
                LendingThanking.create!(lending: lending, thanking: thanking)

                render_to_string partial: 'on_returned_message', locals: {
                  lending: lending,
                  lending_count: lending_count,
                  thanking: thanking
                }

              else
                raise ArgumentError
              end

            client.reply_message(reply_token, { type: 'text', text: response })
          rescue ArgumentError, ActiveRecord::RecordNotFound => error
            client.reply_message(reply_token, { type: 'text', text: "エラーが発生しました。入力値が間違っている可能性があります。" })
          rescue => error
            logger.error error
            client.reply_message(reply_token, { type: 'text', text: " 予期せぬエラーが発生しました。" })
          end
        else
          client.reply_message(reply_token, { type: 'text', text: 'そのメッセージ形式はサポートされていません' })
        end
      end
    end

    head :ok
  end
end
