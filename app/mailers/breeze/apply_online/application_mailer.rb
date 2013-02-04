module Breeze
  module ApplyOnline
    class ApplicationMailer < Breeze::Mailer
      def application_email(application)
        @application = application
        mail :to => application.recipient, :from => application.sender, :subject => application.subject
      end

      def confirmation_email(application)
        @application = application
        mail :to => application.sender, :from => application.recipient, :subject => application.form.confirmation_subject
      end

    protected
      def lookup_context
        @lookup_context ||= (ActionView::LookupContext.new(self.class._view_paths, details_for_lookup)).tap do |context|
          context.view_paths.insert 1, *Breeze::Theming::Theme.view_paths
        end
      end
    end
  end
end
