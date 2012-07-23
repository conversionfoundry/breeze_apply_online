Rails::Application.configure do
  config.to_prepare do
    Breeze::Controller.helper Breeze::ApplyOnline::ApplicationFormHelper
  end
end

Breeze.hook :admin_menu do |menu, user|
  menu << { :name => "Enquiries", :path => "/admin/enquiries" }
end

Breeze.hook :component_info do |component_info|
	component_info << {:name => 'Breeze Pay Online', :version => Breeze::ApplyOnline::VERSION }
end
