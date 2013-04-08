Albums::Application.routes.draw do
  resources :tracks


  resources :albums do
    collection do
      match 'preview'
    end
    member do
      match 'change_cover'
    end
  end
  

  root :to => 'albums#index'


end
