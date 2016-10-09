Rails.application.routes.draw do
  root to: 'messages#new'

  resource :messages, only: [:new, :create]

  match :check, to: 'emails#check', via: [:get, :post]
  match :history, to: 'emails#history', via: [:get, :post]

  resources :webhook_events, path: 'webhooks', only: [:index, :create]
end
