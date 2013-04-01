Albums::Application.routes.draw do
  resources :tracks


  resources :albums


  root :to => 'albums#index'


end
