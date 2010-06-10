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
    end
  end
end
