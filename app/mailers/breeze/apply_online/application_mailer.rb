module Breeze
  module ApplyOnline
    class ApplicationMailer < Breeze::Mailer
      def application_email(application)
        @application = application
        mail :to => application.recipient, :from => application.sender, :subject => application.subject
      end
    end
  end
end
