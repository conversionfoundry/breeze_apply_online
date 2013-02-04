module Breeze
  module ApplyOnline
    module ApplicationFormHelper
      def application_form(options = {}, &block)
        return unless ApplicationPage === view
        form_for view, options.merge(:as => :form, :url => page.permalink, :builder => Breeze::ApplyOnline::ApplicationFormBuilder, :html => { :method => :post }), &block
      end

      ActionView::Helpers::FormHelper.module_eval do
        def apply_form_for_options_with_application_form!(object_or_array, options)
          apply_form_for_options_without_application_form! object_or_array, options
          if Array(object_or_array).first.is_a? Breeze::ApplyOnline::ApplicationPage
            options[:html][:id] = "application_form"
            options[:html][:class] = "application-form #{object_or_array.first.name}-page"
          end
        end
      
        alias_method_chain :apply_form_for_options!, :application_form
      end unless ActionView::Helpers::FormHelper.method_defined? :apply_form_for_options_with_application_form!
    end
  end
end