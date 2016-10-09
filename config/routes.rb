Rails.application.routes.draw do
  root to: 'messages#new'
  resource :messages, only: [:new, :create]
end
