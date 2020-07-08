Rails.application.routes.draw do
  root to: 'pages#home'
  # get 'timezone', to: 'pages#change_timezone', as: :timezone
end
