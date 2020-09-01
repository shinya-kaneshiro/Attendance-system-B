Rails.application.routes.draw do
  get 'users/new'

  root 'static_pages#top'

  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

end
