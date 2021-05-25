require 'line/bot'

module WebhookHelper
  class LineBotClient
    def self.new
      Line::Bot::Client.new do |config|
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      end
    end
  end
end
