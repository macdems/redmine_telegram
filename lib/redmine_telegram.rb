require 'uri'

require File.dirname(__FILE__) + '/redmine_telegram/patches/mailer_patch'
require File.dirname(__FILE__) + '/redmine_telegram/patches/user_patch'
require File.dirname(__FILE__) + '/redmine_telegram/patches/user_preference_patch'

module RedmineTelegram
  class << self

    def setup
      ::Rails.logger.debug 'Redmine Telegram Setup'
      Patches::MailerPatch.apply
      Patches::UserPatch.apply
      UserPreference.send :prepend, Patches::UserPreferencePatch
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
