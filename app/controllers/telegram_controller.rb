class TelegramController < ApplicationController
  skip_before_action :verify_authenticity_token

  def attach start
    user = User.current
    return head :forbidden if user == User.anonymous

    botname = RedmineTelegram::TelegramApi.get_info['username']
    token = Token.new(:user => user, :action => "telegram")
    token.save
    redirect_to "https://t.me/#{botname}/?#{start}=#{token.value}"
  end

  def attach_user
    attach :start
  end

  def attach_group
    attach :startgroup
  end

  def webhook
    return head :forbidden unless params[:secret] == RedmineTelegram.bot_token

    message = params[:message]
    if message && message[:text].start_with?('/start')
      # Handle start command
      words = message[:text].split(' ')
      if words.length == 2
        user = Token.find_active_user('telegram', words[1])
        if user
          user.telegram_chat_id = message[:chat][:id]
          user.pref.save
          RedmineTelegram::TelegramApi.send_message(
            chat_id: message[:chat][:id],
            text: I18n.t(:telegram_user_attached, user: user.name, locale: user.language)
          )
          return head :ok
        end
      end
      RedmineTelegram::TelegramApi.send_message(
        chat_id: message[:chat][:id],
        text: "Please connect your account with Telegram chat in <a href=\"#{Setting.protocol}://#{Setting.host_name}/my/account\">Redmine</a>.",
        parse_mode: 'HTML'
      )
      end
    head :ok
  end
end
