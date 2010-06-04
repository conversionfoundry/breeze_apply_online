module Breeze
  module ApplyOnline
    class ConfirmationPage < ApplicationPage
      def previous?
        false
      end
      
      def render!
        @data = nil
        save_data_to controller.session        
        super
      end
    end
  end
end