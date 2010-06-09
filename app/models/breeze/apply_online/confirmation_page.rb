module Breeze
  module ApplyOnline
    class ConfirmationPage < ApplicationPage
      def previous?
        false
      end
      
      def render!
        application = form.application_class.factory(self)
        if application.save # ...then reset form data in session
          @data = nil
          save_data_to controller.session
        end
        
        super
      end
    end
  end
end