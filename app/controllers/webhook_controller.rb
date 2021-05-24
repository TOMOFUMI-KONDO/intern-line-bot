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

      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = event.message['text'].split(/[\s　]+/)

          response =
            if message[0] == "借りた" && message.length == 3
              "#{message[2]}さんに#{message[1]}を借りました！"
            elsif message[0] == "一覧" && message.length == 1
              '佐藤くん(2個)　100円　マスタリングTCP/IP借りた、田中くん(1個)　研究の調査を手伝ってもらった、......'
            elsif message[0] == "返した" && message.length == 3
              "#{message[2]}さんに#{message[1]}を返しました！"
            else
              '不正な形式のメッセージです'
            end

          client.reply_message(reply_token, { type: 'text', text: response })
        else
          client.reply_message(reply_token, { type: 'text', text: 'そのメッセージ形式はサポートされていません' })
        end
      end
    end

    head :ok
  end
end
