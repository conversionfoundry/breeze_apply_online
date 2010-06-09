module Breeze
  module ApplyOnline
    module FormField
      class RadioField < Base
        def to_html(form)
          form.radio_button_group name, options[:options], clean_options
        end
        
        def output_value(view)
          v = value_for(view)
          Array(options[:options].detect { |o| Array(o).last == v }).first
        end
      end
    end
  end
end