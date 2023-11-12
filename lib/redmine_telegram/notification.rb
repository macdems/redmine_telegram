module RedmineTelegram

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
      #t = Thread.new do
        @chats.each do |chat|
          TelegramApi.send_message(chat_id: chat, text: @message)
        end
      #end
      t.join if Rails.env.test?
      @chats.count
    end
  end

end
