module RedmineTelegram
  class ViewHooks < Redmine::Hook::ViewListener
    render_on :view_my_account_preferences, partial: 'redmine_telegram/hooks/preferences'
  end
end
