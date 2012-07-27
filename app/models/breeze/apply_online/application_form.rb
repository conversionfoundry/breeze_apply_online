module Breeze
  module ApplyOnline
    class ApplicationForm < Breeze::Content::Page
      before_create :define_form_pages
      
      field :subject, :default => "Enquiry from your website"
      field :recipient, :default => "you@example.com"
      field :confirmation_emails, :type => Boolean, :default => false
      field :confirmation_subject, :default => "Thanks!"
      
      validates_presence_of :recipient
      
      # def view_for(controller, request)
      #   if controller.admin_signed_in? && request.params[:view]
      #     views.by_name request.params[:view]
      #   else
      #     current_step = controller.session[:form_data] && controller.session[:form_data][id] && controller.session[:form_data][id][:_step]
      #     views.by_name current_step
      #   end
      # end
      
      def view_for(controller, request)
        if controller.admin_signed_in? && request.params[:view]
          # If an admin has requested a particular view to edit, return that view
          views.by_name request.params[:view]
        else
          # Otherwise, return the view for the current step
          current_step = controller.session[:form_data] && controller.session[:form_data][id] && controller.session[:form_data][id][:_step]
          views.by_name current_step
        end
      end


      def application_class
        Application
      end
      
      def sender_of(application)
        application.data[:email]
      end
      
    protected
      def define_form_pages
        views.build({ :name => "confirmation", :title => "Confirmation" }, Breeze::ApplyOnline::ConfirmationPage)
      end
    end
  end
end