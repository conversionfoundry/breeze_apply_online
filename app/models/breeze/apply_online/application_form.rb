module Breeze
  module ApplyOnline
    class ApplicationForm < Breeze::Content::Page
      before_create :define_form_pages
      
      def view_for(controller, request)
        if controller.admin_signed_in? && request.params[:view]
          views.by_name request.params[:view]
        else
          current_step = controller.session[:form_data] && controller.session[:form_data][id] && controller.session[:form_data][id][:_step]
          views.by_name current_step
        end
      end
      
      def application_class
        Application
      end
      
    protected
      def define_form_pages
        views.build({ :name => "confirmation", :title => "Confirmation" }, Breeze::ApplyOnline::ConfirmationPage)
      end
    end
  end
end