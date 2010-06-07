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
          
          page.class_eval <<-EOS
            def #{name}; all_fields[:#{name}].try :value_for, self; end
            def #{name}?; !#{name}.blank?; end
            def #{name}=(value); data[:#{name}] = value; end
          EOS
          
          add_dependencies
          add_validations
          instance_eval &block if block_given?
        end

        def add_dependencies
          case options[:if]
          when Hash, Array, Symbol then dependencies << Dependency.new(name, options[:if])
          end
        end
        
        def add_validations
          conditional = :"#{name}_dependencies_met?"
          case validator = options[:validate]
          when true   then page.validates_presence_of name, :message => "#{label} cannot be blank", :if => conditional
          when String then page.validates_presence_of name, :message => validator, :if => conditional
          when Proc   then page.validates_each(name) { |r, a, v| validator.call(r, a, v) if r.send conditional }
          when Hash   then page.validates name, validator.merge(:if => conditional)
          when Symbol then page.validates_each(name) { |r, a, v| page.send(validator, r, a, v) if r.send conditional }
          end
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
          (@group.nil? || @group.dependencies_met?(view)) &&
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
        
        def hidden_fields_for(form)
          form.hidden_field name
        end
      end
    end
  end
end