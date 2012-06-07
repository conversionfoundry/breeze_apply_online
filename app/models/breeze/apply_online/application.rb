module Breeze
  module ApplyOnline
    class Application
      include Mongoid::Document
      include Mongoid::Timestamps
      identity :type => String
      
      extend ActiveSupport::Memoizable
      
      field :data, :type => Hash
      field :html
      belongs_to_related :form, :class_name => "Breeze::Content::Page"
      
      after_create :schedule_delivery
      
      def self.factory(confirmation_page)
        returning new(:form => confirmation_page.form) do |response|
          response.data = confirmation_page.data
          response.html = response.to_html
        end
      end
      
      def recipient
        form.recipient
      end
      
      def sender
        form.sender_of self
      end
      
      def subject
        form.subject
      end
      
      def deliver!
        ApplicationMailer.application_email(self).deliver
        if form.confirmation_emails?
          ApplicationMailer.confirmation_email(self).deliver
        end
      end
      
      def html
        read_attribute(:html) || write_html!
      end
      
      def data
        @data ||= read_attribute(:data).with_indifferent_access
      end
      
      def write_html!
        returning to_html do |str|
          write_attribute(:html, str)
        end
      end
      
      def to_html
        returning "" do |html|
          form.views.last.all_previous_steps.each do |step|
            step.form_fields.each do |field|
              html << field.output_html(self)
            end
          end
        end
      end
      
      def all_fields_so_far
        form.views.last.all_fields_so_far
      end
      
      def name
        %w(name first_name firstname last_name lastname surname).map { |f| data[f.to_sym] }.reject(&:blank?).join(" ")
      end
      memoize :name
      
      def email
        %w(email email_address).map { |f| data[f.to_sym] }.reject(&:blank?).first
      end
      memoize :email
      
    protected
      def schedule_delivery
        Breeze.queue self, :deliver!
      end
    end
  end
end
