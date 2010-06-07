module Breeze
  module ApplyOnline
    module FormField
      class Group < Base
        def initialize(page, name, options, &block)
          super page, name, options, &block
        end
        
        def method_missing(sym, *args, &block)
          if /^(\w+_field)$/ === sym.to_s
            options = args.extract_options!
            options[:group] = self
            args << options
            contents << "Breeze::ApplyOnline::FormField::#{$1.classify}".constantize.new(page, *args, &block)
          else
            super
          end
        end
        
        def field_group(*args, &block)
          options = args.extract_options!
          options[:group] = self
          args << options
          contents << Breeze::ApplyOnline::FormField::Group.new(page, *args, &block)
        end
        
        def text(string)
          contents << Breeze::ApplyOnline::FormField::Text.new(page, :"text_#{string.hash}", :text => string)
        end
        
        def legend
          options[:legend] || name.to_s.humanize
        end
        
        def to_html(form)
          fieldset = form.template.content_tag(:fieldset,
            (
              (options[:legend] == false ? "" : form.template.content_tag(:h2, legend)) + 
              form.template.content_tag(:ol,
                contents.map { |f| f.to_html(form) }.join("\n").html_safe
              )
            ).html_safe,
            clean_options.except(:wrap).merge(:id => name)
          ).html_safe
          form.template.content_tag @group ? :li : :div, fieldset, :id => "form_field_wrapper_#{name}"
        end
        
        def hidden_fields_for(form)
          ""
        end
      end
    end
  end
end