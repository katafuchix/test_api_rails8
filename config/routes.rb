Rails.application.routes.draw do
  #mount_devise_token_auth_for 'User', at: 'auth'
  # 修正後：ブラウザでのログイン・サインアップを有効にする
  #devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # 2. ブラウザ用の一般ユーザー認証
  # /users/sign_in などの標準的な画面を提供
  devise_for :users
  # 自動生成されるルートを「ゼロ」にする設定
  #devise_for :users, skip: :all

 # API用：ヘルパーメソッドの生成を完全にスキップし、名前の衝突を回避
  namespace :api, defaults: { format: :json } do
    post 'login',  to: 'sessions#create', as: :api_login, skip_helpers: true
    post 'signup', to: 'registrations#create', as: :api_signup, skip_helpers: true
    delete 'logout', to: 'sessions#destroy', as: :api_logout, skip_helpers: true
  end
end
