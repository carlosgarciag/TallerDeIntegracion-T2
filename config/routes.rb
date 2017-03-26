Rails.application.routes.draw do
  get 'welcome/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :usuario, defaults: { format: :json }, :only => [:index, :show]
  put '/usuario' => 'usuario#create'
  delete '/usuario/:id' => 'usuario#destroy'
  post 'usuario/:id' => 'usuario#update'
  
  root "welcome#index"
end
