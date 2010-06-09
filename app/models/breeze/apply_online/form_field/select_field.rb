module Breeze
  module ApplyOnline
    module FormField
      class SelectField < Base
        def to_html(form)
          form.select name, options[:options], clean_options, options[:html] || {}
        end
        
        def output_value(view)
          v = value_for(view)
          Array(options[:options].detect { |o| Array(o).last == v }).first
        end
      end
    end
  end
end