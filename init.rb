require 'redmine'
require File.dirname(__FILE__) + '/lib/redmine_telegram/view_hooks'

Redmine::Plugin.register :redmine_telegram do
  name 'Redmine Telegram Notifications Plugin'
  description 'Get push notifications from Redmine via Telegram.'
  author     'Maciej Dems'
  version '0.2'
  requires_redmine version_or_higher: '2.6.0'
  settings partial: 'settings/telegram', default: { strip_signature: '1' }
end

RedmineTelegram.setup
