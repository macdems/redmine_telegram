require 'httparty'

module RedmineTelegram
  class TelegramApi
    include HTTParty

    base_uri "https://api.telegram.org/bot#{RedmineTelegram::bot_token}"

    def self.send_message message
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

    def self.set_webhook
      options = RedmineTelegram.proxy_options
      options[:query] = { url: RedmineTelegram::webhook_url }
      r = post '/setWebhook', options
      if r['ok']
        if Rails.logger.debug?
          Rails.logger.degug "Telegram webhook set to: #{options[:query][:url]}\n#{r}"
        end
        true
      else
        Rails.logger.warn "Telegram request failed:\n#{options[:query]}\n\n#{r}"
        false
      end
    end

    def self.get_info
      options = RedmineTelegram.proxy_options
      r = get '/getMe', options
      if r['ok']
        if Rails.logger.debug?
          Rails.logger.degug "Telegram bot info:\n#{r}"
        end
        r.parsed_response['result']
      else
        Rails.logger.warn "Telegram request failed:\n\n#{r}"
        false
      end
    end

    def self.get_chat_info chat_id
      options = RedmineTelegram.proxy_options
      options[:query] = { chat_id: chat_id }
      r = post '/getChat', options
      if r['ok']
        if Rails.logger.debug?
          Rails.logger.degug "Telegram chat info:\n#{r}"
        end
        r.parsed_response['result']
      else
        Rails.logger.warn "Telegram request failed:\n\n#{r}"
        false
      end
    end

  end
end
