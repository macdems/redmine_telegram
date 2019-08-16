module RedmineTelegram
  module Patches
    module UserPreferencePatch

      def self.prepended(base)
        base.class_eval do
          if defined? safe_attributes
            safe_attributes :telegram_enabled
            safe_attributes :telegram_chat_id
            safe_attributes :telegram_skip_emails
          end
        end
      end

      def telegram_enabled; (self[:telegram_enabled] == true || self[:telegram_enabled] == '1'); end
      def telegram_enabled=(value); self[:telegram_enabled]=value; end

      def telegram_chat_id; self[:telegram_chat_id]; end
      def telegram_chat_id=(value); self[:telegram_chat_id]=value; end

      def telegram_skip_emails; (self[:telegram_skip_emails] == true || self[:telegram_skip_emails] == '1'); end
      def telegram_skip_emails=(value); self[:telegram_skip_emails]=value; end

    end
  end
end

