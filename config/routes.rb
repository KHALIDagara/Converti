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
  end

  root "landing_pages#index"
end
