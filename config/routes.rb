# -*- encoding : utf-8 -*-

Cba::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  namespace :backend do resources :offers end

  namespace :backend do
    root to: "locations#index"
    get "remove_user/:time_slot_id/user/:user_id" => "time_slots#delete_user", as: :remove_user
    resources :locations do
      get "calendar"
      resources :events
      resources :fitness_camps do
        resources :time_slots do
          get "re_register" => "time_slots#re_register", as: :re_register
          post "process_repeat_registrations" => "time_slots#process_repeat_registrations", as: :process_repeat_registrations
          get "attendance_sheet/:time_slot_id" => "time_slots#attendance_sheet", as: :attendance_sheet
          get "emergency_contact/:time_slot_id" => "time_slots#emergency_contact", as: :emergency_contact
          post "register_user"
          get "attendance"
          resources :prizes
          resources :meetings do
             match "take_attendance"
          end
        end
      end
    end

    post "add_meetings/:time_slot_id" => "meetings#add_meetings", as: :add_meetings
    get "add_workout_for_user/:user_id/meeting/:meeting_id" => "workout_tracker#add_workout_for_user", as: :add_workout_for_user
    get "coach_enters_scores/:meeting_id" => "workout_tracker#coach_enters_scores", as: :coach_score_entry
    #get "show_workout_results/:meeting_id" => "meetings#show_workout_results", as: :show_workout_results
    #match 'fitness_camp_registration/add_to_cart/:id' => "fitness_camp_registration#add_to_cart", as: "add_to_cart"
    match "delete_workout/:workout_id" => "workout_tracker#delete_workout", as: :delete_workout
    #delete_workout
    post "update_workout_for_user" => "workout_tracker#update_workout_for_user", as: :update_workout_for_user
    put "update_workouts_for_camp/:id" => "workout_tracker#update_workouts_for_camp", as: :update_workouts_for_camp

    resources :users do
      resources :user_prs
      resources :measurements
      resources :goals
      resources :custom_workouts
      resources :health_issues
    end

    resources :friends
    resources :fit_wit_workouts
    resources :workouts
    resources :sponsors
    resources :coupon_codes
    resources :news_items
    resources :medical_conditions
  end

  get "my_fit_wit/index"
  get "my_fit_wit/camp_fit_wit_workout_progress"
  get "add_custom_workout/:date" => "my_fit_wit#add_custom_workout", as: :add_custom_workout
  get "show_custom_workout/:id" => "my_fit_wit#show_custom_workout", as: :show_custom_workout
  # goals -- should remove
  get "my_fit_wit/my_goals"
  post "my_fit_wit/add_goal"
  match "my_fit_wit/delete_goal/:goal_id" => "my_fit_wit#delete_goal", as: :my_fit_wit_delete_goal
  match "my_fit_wit/update_goal/:goal_id" => "my_fit_wit#update_goal", as: :my_fit_wit_update_goal
  get "my_fit_wit/fit_wit_workout_progress"
  # add measurements
  post "my_fit_wit/add_new_measurement"

  #unsure
  get "my_fit_wit/leader_board/:id" => "my_fit_wit#leader_board"
  get "my_fit_wit/upcoming_fitnesscamps"
  get "my_fit_wit/get_progress_chart"
  get "my_fit_wit/past_fitnesscamps"
  get "my_fit_wit/load_calendar_date"
  get "my_fit_wit/specific_fit_wit_workout"
  get "my_fit_wit/get_calendar_events"
  get "my_fit_wit/list_fit_wit_workout"
  get "my_fit_wit/find_previous_scores"

  # FitWit Routes
  get "base/locations", as: "locations"
  get "base/camp_details", as: "camp_details"
  get "base/whats_included", as: "whats_included"
  get "base/faq", as: "faq"
  get "base/price", as: "price"
  get "base/referrals", as: "referrals"
  get "base/getting_started", as: "getting_started"
  get "base/non_profit", as: "non_profit"
  #get "base/stories", as: "stories"
  get "base/team"
  get "base/company_story", as: "company_story"
  get "base/camper_stories", as: "camper_stories"
  get "base/team_story", as: "team_story"
  get "base/contact", as: "contact"
  post "base/create_contact_message"
  get 'base/posts'

  # stories
  get "base/stories/amanda" => "base#amanda"
  get "base/stories/arthur_and_anna" => "base#arthur_and_anna"
  get "base/stories/brandi" => 'base#brandi'
  get "base/stories/catherine" => 'base#catherine'
  get "base/stories/christina" => 'base#christina'
  get "base/stories/dawn" => 'base#dawn'
  get "base/stories/denise" => 'base#denise'
  get "base/stories/greg" => 'base#greg'
  get "base/stories/jose" => 'base#jose'
  get "base/stories/katherine" => 'base#katherine'
  get "base/stories/lisa" => 'base#lisa'
  get "base/stories/mary" => 'base#mary'
  get "base/stories/mike" => 'base#mike'
  get "base/stories/pam" => 'base#pam'
  get "base/stories/carey" => 'base#carey'

  # fitness camp registrations
  match 'fitness_camp_registration/add_to_cart/:id' => "fitness_camp_registration#add_to_cart", as: "add_to_cart"
  match 'fitness_camp_registration/release_and_waiver_of_liability'
  match 'fitness_camp_registration/medical_conditions'
  match 'fitness_camp_registration/terms_of_participation'
  get 'fitness_camp_registration/update_profile'
  match 'cart_item/add_friend' => "cart_item#add_friend", as: :add_friend
  match "cart_item/remove_friend/:friend_name/:unique_id" => "cart_item#remove_friend", as: :remove_friend
  match 'cart_item/add_coupon' => "cart_item#add_coupon", as: :add_coupon
  match "cart_item/remove_coupon/:friend_name/:unique_id" => "cart_item#remove_coupon", as: :remove_coupon
  match "cart_item/add_pay_by_session/:number_of_sessions/:unique_id" => "cart_item#add_pay_by_session", as: :add_sessions_to_cart
  match "cart_item/set_traditional/:unique_id" => "cart_item#set_traditional", as: :set_traditional
  match 'fitness_camp_registration/cart' => "fitness_camp_registration#cart"

  get 'fitness_camp_registration/index'
  get 'fitness_camp_registration/no_need_to_register'
  get 'fitness_camp_registration/process_fit_wit_history'
  get 'fitness_camp_registration/membership_info'
  match 'fitness_camp_registration/consent'
  get 'fitness_camp_registration/health_history'
  match 'fitness_camp_registration/payment'
  post 'fitness_camp_registration/pay'

  post "update_health_items" => "fitness_camp_registration#update_health_items"

  post 'fitness_camp_registration/empty_cart'
  get 'fitness_camp_registration/registration_success/:order_id' => "fitness_camp_registration#registration_success", as: :successful_registration
  get 'fitness_camp_registration/all_fitness_camps'
  get 'registration/all_fitness_camps' => "fitness_camp_registration#all_fitness_camps"
  # Switch locales
  match 'switch_locale/:locale' => "home#set_locale", :as => 'switch_locale'
  
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

  get "calendar/events/:id" => "calendar#events"
  get "calendar/all_camp_events/:id" => "calendar#all_camp_events"
  get "calendar/all_events/" => "calendar#all_events"
  get "calendar/location_calendar/:location_id" => "calendar#location_calendar", :as => 'location_calendar'
  get "calendar/fit_wit_calendar" => "calendar#fit_wit_calendar"
  get "calendar/display_event/:event_id" => "calendar#display_event"

  match 'feed' => "home#rss_feed", :as => 'feed'
  match 'activity' => "home#fit_wit_activity", as: 'activity'

  # PAGES
  match '/p/:permalink' => 'pages#permalinked', :as => 'permalinked'
  resources :pages do
    member do
      get :delete_cover_picture
      get :sort_components
      post :sort_components
    end
    collection do
      get  :new_article
      post :create_new_article
      get  :templates
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
  match 'profile/:id'   => 'users#show', :as => 'profile'
  match 'my_group_ids'  => 'users#my_group_ids'

  get "users/fitwit_admin"
  get "users/contact_info"
  get "users/health_profile"
  get "users/authentications_update"
  put "users/update_profile/" => "users#update_profile", as: :update_user_profile
  match "users/update_health_history"
  put "users/update_password"

  devise_for :users, :controllers => { :registrations => 'registrations' }

  resources :users do
    resources :custom_workouts, only: [:create, :update, :destroy]
  end

  resources :users, :only => [:show,:destroy] do
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
  resources :authentications, :only => [:index,:create,:destroy]
  match '/auth/failure' => 'authentications#auth_failure'

  resources :user_notifications do
    collection do
      get :emails
    end
  end

  # ROOT
  match "fitwit_blogs" => "home#index"
  #root :to => 'home#index'
  root :to => "home#start_page"

end
