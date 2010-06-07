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
        
        def dependencies_met?(view)
          true
        end
      end
    end
  end
end