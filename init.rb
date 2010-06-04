Rails::Application.configure do
  config.to_prepare do
    Breeze::Controller.helper Breeze::ApplyOnline::ApplicationFormHelper
  end
end
