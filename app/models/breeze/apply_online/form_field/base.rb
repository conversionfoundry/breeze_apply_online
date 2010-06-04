module Breeze
  module ApplyOnline
    module FormField
      class Base
        attr_accessor :name
        attr_accessor :options
        
        def initialize(name, options = {}, &block)
          @name, @options = name.to_sym, options || {}
          @block = block if block_given?
        end
        
        def label
          options[:label] || name.to_s.humanize
        end
        
        def value_for(view)
          view.data[name] || options[:default] || ""
        end
        
        def required?
          !!options[:required]
        end
        
        def to_html(form)
          if @block
            @block.call(form)
          else
            field_html(form)
          end
        end
        
        def field_html(form)
          form.text_field name, options.except(:default)
        end
      end
    end
  end
end