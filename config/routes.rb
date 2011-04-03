Pymeprivee::Application.routes.draw do

  get "/sale_items/:id/add_product" => "sale_items#add_product", :as => 'add_product_to_sale_item'
  post "/sale_items/:id/add_product" => "sale_items#update_products", :as => 'update_products_for_sale_item'
  resources :shops do
    collection { get :my_shop }
    resources :products
    resources :sale_items do
      collection { get :current }
      member { get :buy }
    end
  end
  
  match "/my_shop" => redirect("/shops/my_shop"), :as => "user_root"

  constraints(:host => "conejos.com") do
    match "/" => "shops#by_hostname"
  end
  
  resources :payments do
    member do
      get :confirm
      post :complete
    end
  end

  devise_for :users

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
  
  get '/widgets/shop/:shop_id/current' => "sale_items#show" 
  root :to => "home#index"
end
