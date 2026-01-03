Rails.application.routes.draw do
  resources :landing_pages do 
    member do 
      patch :update_reviews
      get :business_details
      get :styles 
      get :services
      get :copywriting
    end
    resources :services, only: [:new, :create, :edit, :update, :destroy] do
      collection do
        get :test  # This creates: test_landing_page_services_path(@landing_page)
        get :test2
      end
    end


    resources :channels 
       collection whatsapp_numbers  do 
          get index_channel_whatsapp_number_path : 
          post create_channel_whatsapp_number(@channel)
       end
    end 
  end

  root "landing_pages#index"
end
