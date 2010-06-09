module Breeze
  module ApplyOnline
    class Application
      include Mongoid::Document
      include Mongoid::Timestamps
      
      field :data, :type => Hash
      field :html
      belongs_to_related :form, :class_name => "Breeze::Content::Page"
      
      after_create :deliver!
      
      def self.factory(confirmation_page)
        returning new(:form => confirmation_page.form) do |response|
          response.data = confirmation_page.data
          response.html = response.to_html
        end
      end
      
      def recipient
        "matt@leftclick.com"
      end
      
      def sender
        "matt@leftclick.com"
      end
      
      def subject
        "Form response"
      end
      
      def deliver!
        ApplicationMailer.application_email(self).deliver
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
    end
  end
end