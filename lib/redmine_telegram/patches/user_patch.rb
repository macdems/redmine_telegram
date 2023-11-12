module RedmineTelegram
  module Patches
    module UserPatch

      def self.apply
        User.class_eval do
          prepend InstanceMethods
        end
      end

      module InstanceMethods

        def telegram_chat_id
          pref.telegram_chat_id
        end

        def wants_telegram?
          pref.telegram_enabled and telegram_chat_id.present?
        end

        def wants_only_telegram?
          pref.telegram_skip_emails
        end

      end

    end
  end
end
