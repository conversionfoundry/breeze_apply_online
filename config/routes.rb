Rails.application.routes.draw do
  devise_for :admin, :class_name => "Breeze::Admin::User"

  scope "admin", :name_prefix => "admin", :module => "breeze/apply_online" do
    resources :enquiries
  end
end