require 'uri'

require File.dirname(__FILE__) + '/redmine_telegram/patches/mailer_patch'
require File.dirname(__FILE__) + '/redmine_telegram/patches/user_patch'
require File.dirname(__FILE__) + '/redmine_telegram/patches/user_preference_patch'
require File.dirname(__FILE__) + '/redmine_telegram/patches/token_patch'

module RedmineTelegram
  class << self

    def setup
      ::Rails.logger.debug 'Redmine Telegram Setup'
      Patches::MailerPatch.apply
      Patches::UserPatch.apply
      UserPreference.send :prepend, Patches::UserPreferencePatch
      TelegramApi.set_webhook
    end

    def bot_token
      Setting.plugin_redmine_telegram['bot_token']
    end

    def configured?
      Setting.plugin_redmine_telegram['bot_token'].present?
    end

    def strip_signature?
      Setting.plugin_redmine_telegram['strip_signature'].to_s == '1'
    end

    def webhook_url
      "#{Setting.protocol}://#{Setting.host_name}/telegram/#{bot_token}"
    end

    def chat_name user
      chat_id = user.pref.telegram_chat_id
      if chat_id
        chat = TelegramApi.get_chat_info chat_id
        if chat['type'] == 'private'
          return "#{chat['first_name']} #{chat['last_name']}"
        else
          return chat['title']
        end
      end
      chat_id
    end

    def proxy_options
      {}.tap do |opts|
        if addr = Setting.plugin_redmine_telegram['http_proxy_addr'].presence
          opts[:http_proxy_addr] = addr
          opts[:http_proxy_port] =
            Setting.plugin_redmine_telegram['http_proxy_port'].presence
        end
      end
    end

  end
end
