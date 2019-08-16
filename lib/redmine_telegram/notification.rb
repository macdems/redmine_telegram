require 'httparty'

module RedmineTelegram

  class TelegramApi
    include HTTParty

    base_uri "https://api.telegram.org/bot#{RedmineTelegram::bot_token}"

    def self.send_message(message)
      options = RedmineTelegram.proxy_options
      options[:query] = message

      r = post '/sendMessage', options
      if r['ok']
        if Rails.logger.debug?
          Rails.logger.debug "Telegram message sent:\n#{message}\n\n#{r}"
        end
        true
      else
        Rails.logger.warn "Telegram request failed:\n#{message}\n\n#{r}"
        false
      end
    end

  end
  
  class Notification

    def initialize(mail)
      @chats = []
      @message = get_message(mail)
    end

    def get_message(mail)
      (mail.text_part || mail).body.to_s.tap do |text|
        text.sub! Setting.emails_header.strip, '' if Setting.emails_header.present?
        text.sub! /^-- ?\n.*\z/m, '' if RedmineTelegram::strip_signature?
        text.strip!
      end#[0..1023]
    end

    def add_user(user)
      @chats << user.telegram_chat_id
    end

    def deliver!
      message = {
        text: @message,
      }
      #t = Thread.new do
        @chats.each do |chat|
          message[:chat_id] = chat
          TelegramApi.send_message message
        end
      #end
      t.join if Rails.env.test?
      @chats.count
    end

  end

end
