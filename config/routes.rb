HotelMgtWithWorkflowChanged::Application.routes.draw do
  
  

  
  post  "room_books/action_gds_conf"
  
  post "room_books/add_room"
  get  "room_books/add_room"
  post "room_books/add_room_date"
  get "room_books/add_room_date"
  #get "room_books/confirm_room"
  
  
  post 'room_books/get_available_room_type'
  get 'room_books/get_available_room_type'
  
  post 'room_books/add_to_gds'
  
  post 'room_books/delete_gdsline'
  
  get 'room_books/show_type/:id' => "room_books#show_type"
  post "room_books/available_for_gds" => "room_books#available_for_gds"
  post "room_books/available_for_gds/:id" => "room_books#available_for_gds"
  
  get "room_books/available_for_gds/:id" => "room_books#available_for_gds"
  get "room_books/edit_available_for_gds/:id" => "room_books#edit_available_for_gds"
  
  post "room_books/delete_allocated_room" => "room_books#delete_allocated_room"
  get "room_books/add_an_item"
  post "room_books/add_an_item"
  
  get "room_books/show_view/:id" => "room_books#show_view"
  
  get "room_books/select_shop"
  
  
  
  resources :room_books


  post "reservations/show_dates"
  get  "reservations/show_dates"
  post "reservations/show_availability_of_rooms"
  get  "reservations/room_confirm/:id" => "reservations#room_confirm"
  post  "reservations/room_confirm/" => "reservations#room_confirm"
  
  
  
  resources :reservations
  
  
  get "payments/preview_payment"
  
  #post "payment/payment_check"
  post "payments/checkout"
  get "payments/confirm"
  get "payments/cancel"
  post "payments/complete"
  get "payments/rejected_payment"
  resources :payments
  
   
  
  
   
  root :to => "authenticates#select_company"
  post "authenticates/sign_in"
  get  "authenticates/sign_in"
  get  "authenticates/sign_up"
  post "authenticates/sign_up"
  post "authenticates/sign_in_auth"
  post "/authenticates/sign_up_auth"
  get "/authenticates/forgot_password"
  post "/authenticates/forgot_password_auth"
  get "/authenticates/sign_out"
  
    
  
  resources :authenticates


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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  
  
  #here copying all the routes from gds system
  
  resources :admins

  resources :updateretes

  resources :updatehoteltexts

  resources :updatebookings
  get "updateavails/all_list"
  get "updateavails/show_type/:id" => "updateavails#show_type"
  post "updateavails/available_for_gds/" => "updateavails#available_for_gds"
  post "delete_allocated_room" => "updateavails#delete_allocated_room"
  get "updateavails/get_dates" => "updateavails#get_dates"
  post "get_date_wise_available_room" => "updateavails#get_date_wise_available_room"
  post "add_to_gds" => "updateavails#add_to_gds"
  
  get "count_rooms" => "updateavails#count_rooms"
  #from above 1 route i am changing it in 2 pages like first page is just of link and second page will be do the
  #actual counting and upgrading the rooms in reconline
  get "update_count_rooms" => "updateavails#update_count_rooms"
  
  
  
  
  resources :updateavails

  resources :setmarkassents

  resources :setds

  resources :getroomratecodefbs

  resources :getroomratecodes

  resources :getratesdbs

  resources :getrates

  resources :getnotificationmessages

  resources :getinvoicedata

  resources :gethotels

  resources :gethotelstaticdatagds

  resources :gethotelstaticdata

  resources :getcommissionstatuses

  resources :getbookings

  resources :getavailfbs

  resources :cancelbookings

  resources :bookings

  get "savontest/index"
  
  get "gds_auth" => "gds_auths#index"
  
  get "gds_select_company" => "gds_auths#gds_select_company"
  
  get "logout" => "gds_auths#logout"
  
      
  resources :gds_auths

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
end
