Albums::Application.routes.draw do
  resources :tracks


  resources :albums do
    collection do
      match 'preview'
    end
  end
  

  root :to => 'albums#index'


end
