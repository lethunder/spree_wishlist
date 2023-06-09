Spree::Core::Engine.add_routes do
  resources :wishlists do
    collection do
      post "/add_item_to_wishlist", to: "wishlists#add_item", as: "add_item"
    end
  end
  resources :wished_products, only: [:create, :update, :destroy]
  get '/wishlist' => "wishlists#default", as: "default_wishlist"

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :wishlists
      resources :wished_products, only: [:create, :update, :destroy]
    end

    namespace :v2 do
      namespace :storefront do
        resources :wishlists do
          get 'default', on: :collection
          resources :wished_products, only: [:create, :update, :destroy]
        end
      end
    end
  end
end
