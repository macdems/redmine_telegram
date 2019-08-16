require_dependency 'redmine_telegram'
require_dependency 'redmine_telegram/view_hooks'

Redmine::Plugin.register :redmine_telegram do
  name 'Redmine Telegram Notifications Plugin'

  description 'Get push notifications from Redmine via Telegram.'

  author     'Maciej Dems'

  version '0.1'

  requires_redmine version_or_higher: '2.6.0'

  settings partial: 'settings/telegram', default: { strip_signature: '1' }
end

Rails.configuration.to_prepare do
  RedmineTelegram.setup
end

