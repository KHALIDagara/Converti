Rails.application.routes.draw do
  resources :landing_pages do
    member do
      patch :update_reviews
      get :business_details
      patch :update_business_details
      get :styles
      patch :update_styles
      get :services
      get :copywriting
      patch :update_copywriting
    end

    resources :services, only: [:new, :create, :edit, :update, :destroy] do
      collection do
        get :test  # Creates: test_landing_page_services_path(@landing_page)
        get :test2
      end
    end
  end

  resources :channels 

  post '/webhooks/whatsapp/:instance_name', to: 'whatsapp#webhook'

  root "landing_pages#index"
end
