Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'kittens#index'

  resources :kittens do 
    member do 
      get "likers"
      #match "likers" => "kittens#likers", :via => :get
    end
  end

  resources :users, only: :create do
    collection do
      post 'login'
    end
  end
  resources :likes, only: [:create, :destroy]
end
