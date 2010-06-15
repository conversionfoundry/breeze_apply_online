module Breeze
  module ApplyOnline
    module FormField
      class CheckBoxField < Base
        unloadable
        
        def initialize(page, name, options = {}, &block)
          super page, name, options.reverse_merge(:default => "0"), &block
        end
        
        def to_html(form)
          form.check_box name, clean_options
        end
        
        def output_value(view)
          case value_for(view)
          when true, 1, "1" then "Yes"
          else "No"
          end
        end
      end
    end
  end
end