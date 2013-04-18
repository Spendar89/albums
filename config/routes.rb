Albums::Application.routes.draw do
  resources :tracks do
    member do
      match 'count_play'
    end
  end


  resources :albums do
    collection do
      match 'preview'
    end
    member do
      match 'change_cover'
    end
  end
  
  resources :artists do
  end

  root :to => 'albums#index'


end
