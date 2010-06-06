module Breeze
  module ApplyOnline
    module FormField
      class Base
        attr_accessor :page
        attr_accessor :name
        attr_accessor :options
        attr_accessor :contents
        attr_accessor :dependencies

        def initialize(page, name, options = {}, &block)
          @page, @name, @options = page, name.to_sym, options || {}
          @group = @options.delete :group
          case validator = options[:validate]
          when true   then page.validates_presence_of name, :message => "#{label} cannot be blank"
          when String then page.validates_presence_of name, :message => validator
          when Proc   then page.validates_each name, &validator
          when Hash   then page.validates name, validator
          when Symbol then page.validates_each(name) { |r, a, v| page.send validator, r, a, v }
          end
          instance_eval &block if block_given?
        end
        
        def all_fields
          [ self, contents.map(&:all_fields) ]
        end
        
        def contents
          @contents ||= []
        end
        
        def dependencies
          @dependencies ||= []
        end
        
        def value_for(view)
          view.data[name] || options[:default]
        end
        
        def dependencies_met?(view)
          (@group.nil || @group.dependencies_met?(view)) &&
          dependencies.inject(true) { |v, d| v && d.met?(view) }
        end
        
        def label
          options[:label] == false ? "" : (options[:label] || name.to_s.humanize)
        end
        
        def required?
          options[:validate].present?
        end

        def clean_options
          options.except(:if, :validate, :default, :options, :html).reverse_merge(:required => required?, :wrap => { :id => "form_field_wrapper_#{name}" })
        end

        def to_html(form)
          form.text_field name, clean_options
        end
      end
    end
  end
end