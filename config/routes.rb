Breeze::Engine.routes.draw do
  namespace "admin" do
    namespace "apply_online" do
      resources :enquiries
    end
  end

  # devise_for :admin, :class_name => "Breeze::Admin::User"
end


# Rails.application.routes.draw do
#   devise_for :admin, :class_name => "Breeze::Admin::User"

#   scope "admin", :name_prefix => "admin", :module => "breeze/apply_online" do
#     resources :enquiries
#   end
# end