Albums::Application.routes.draw do
  resources :tracks do
    member do
      match 'count_play'
    end
  end


  resources :albums do
    collection do
      match 'preview'
      match 'block'
    end
    member do
      match 'change_cover'
    end
  end
  
  resources :artists do
    collection do
      match 'search'
    end
  end

  root :to => 'albums#index'


end
