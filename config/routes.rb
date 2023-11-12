
Rails.application.routes.draw do
  post '/telegram/:secret', to: 'telegram#webhook'
  get '/telegram/attach/user', to: 'telegram#attach_user'
  get '/telegram/attach/group', to: 'telegram#attach_group'
end
