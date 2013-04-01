Albums::Application.routes.draw do
  resources :tracks


  resources :albums do
    collection do
      get 'preview'
    end
  end
  

  root :to => 'albums#index'


end
