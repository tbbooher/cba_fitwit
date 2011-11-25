# -*- encoding : utf-8 -*-

Cba::Application.routes.draw do

  resources :measurements

  resources :goals

  resources :custom_workouts

  get "my_fit_wit/index"
  get "my_fit_wit/profile"
  get "my_fit_wit/upcoming_fitnesscamps"
  get "my_fit_wit/add_custom_workout"
  get "my_fit_wit/input_custom_workout"
  get "my_fit_wit/leader_board"
  get "my_fit_wit/get_progress_chart"
  get "my_fit_wit/fit_wit_workout_details"
  get "my_fit_wit/update"
  get "my_fit_wit/past_fitnesscamps"
  get "my_fit_wit/camp_fit_wit_workout_progress"
  get "my_fit_wit/my_goals"
  get "my_fit_wit/add_goal"
  get "my_fit_wit/delete_goal"
  get "my_fit_wit/update_goal"
  get "my_fit_wit/fit_wit_workout_progress"
  get "my_fit_wit/add_new_measurement"
  get "my_fit_wit/load_calendar_date"
  get "my_fit_wit/specific_fit_wit_workout"
  get "my_fit_wit/process_fit_wit_history"
  get "my_fit_wit/health_history"
  get "my_fit_wit/get_calendar_events"
  get "my_fit_wit/list_fit_wit_workout"
  get "my_fit_wit/find_previous_scores"
  get "my_fit_wit/get_user_id"
  get "my_fit_wit/zero_out_all_unchecked_explanations"
  get "my_fit_wit/user_has_not_explained_themself"
  get "my_fit_wit/get_inches_height"
  get "my_fit_wit/get_months_and_years"

  resources :friends
  resources :prs
  resources :fit_wit_workouts
  resources :workouts
  resources :meetings
  resources :locations
  resources :sponsors
  resources :events

  get "calendar/index"

  resources :news_items

  # FitWit Routes

  get "base/locations", as: "locations"
  get "base/camp_details", as: "camp_details"
  get "base/whats_included", as: "whats_included"
  get "base/faq", as: "faq"
  get "base/price", as: "price"
  get "base/schedule", as: "schedule"
  get "base/non_profit", as: "non_profit"
  get "base/stories", as: "stories"
  get "base/company_story", as: "company_story"
  get "base/camper_stories", as: "camper_stories"
  get "base/contact", as: "contact"
  get 'base/error'
  get 'base/posts'

  # fitness camp registrations
  get 'fitness_camp_registration/index'
  match 'fitness_camp_registration/add_to_cart/:id' => "fitness_camp_registration#add_to_cart", as: "add_to_cart"
  get 'fitness_camp_registration/no_need_to_register'
  match 'fitness_camp_registration/release_and_waiver_of_liability'
  match 'fitness_camp_registration/terms_of_participation'
  get 'fitness_camp_registration/process_fit_wit_history'
  match 'fitness_camp_registration/view_cart' => "fitness_camp_registration#view_cart"
  match 'fitness_camp_registration/add_discounts' => "fitness_camp_registration#add_discounts"
  get 'fitness_camp_registration/membership_info'
  get 'fitness_camp_registration/consent'
  get 'fitness_camp_registration/health_history'
  get 'fitness_camp_registration/payment'
  get 'fitness_camp_registration/pay'
  match 'fitness_camp_registration/save_order'
  get 'fitness_camp_registration/empty_cart'
  get 'fitness_camp_registration/registration_success'
  get 'fitness_camp_registration/all_fitness_camps'

  # Switch locales
  match 'switch_lcoale/:locale' => "home#set_locale", :as => 'switch_locale'

  # Switch draft mode
  match 'draft_mode/:mode' => "home#set_draft_mode", :as => 'draft_mode'

  match 'search' => "search#index", :as => 'searches'

  # Comments
  resources :comments, :except => :show

  # Tags
  match '/tag/:tag' => "home#tags", :as => 'tags'

  # SiteMenu
  resources :site_menus do
    collection do
      post :sort_menus
    end
  end

  # BLOGS
  resources :blogs do
    member do
      get :delete_cover_picture
    end
    resources :postings do
      member do
        get :delete_cover_picture
      end
      resources :comments
    end
  end
  resources :postings, only: [:show] do
    collection do
      get :tags
    end
  end

  match 'feed' => "home#rss_feed", :as => 'feed'

  # PAGES
  match '/p/:permalink' => 'pages#permalinked', :as => 'permalinked'
  resources :pages do
    member do
      get :delete_cover_picture
      get :sort_components
      post :sort_components
    end
    collection do
      get :new_article
      post :create_new_article
      get :templates
    end
    resources :comments
    resources :page_components
  end

  # PAGE TEMPLATES
  resources :page_templates

  # USERS
  match 'registrations' => 'users#index', :as => 'registrations'
  match 'hide_notification/:id' => 'users#hide_notification', :as => 'hide_notification'
  match 'show_notification/:id' => 'users#show_notification', :as => 'show_notification'
  match 'notifications' => 'users#notifications', :as => 'notifications'
  match 'profile/:id' => 'users#show', :as => 'profile'

  devise_for :users, :controllers => {:registrations => 'registrations'}
  resources :users, :only => [:show, :destroy] do
    resources :invitations
    resources :user_groups
    resources :user_notifications
    member do
      get :crop_avatar
      put :crop_avatar
      get :edit_role
      put :update_role
      get :details
    end
    collection do
      get :autocomplete_ids
    end
  end

  # AUTHENTICATIONS
  match '/auth/:provider/callback' => 'authentications#create'
  resources :authentications, :only => [:index, :create, :destroy]
  match '/auth/failure' => 'authentications#auth_failure'

  resources :user_notifications do
    collection do
      get :emails
    end
  end

  # ROOT
  #root :to => 'home#index'
  root :to => "home#start_page"

end
