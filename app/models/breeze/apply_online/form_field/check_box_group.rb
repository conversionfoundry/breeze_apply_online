module Breeze
  module ApplyOnline
    module FormField
      class CheckBoxGroup < Base
        def to_html(form)
          form.check_box_group name, options[:options], clean_options
        end
        
        def output_value(view)
          v = value_for(view)
          choices = options[:options].map { |o| o.is_a?(Array) ? o : [ Symbol === o ? o.to_s.humanize : o.to_s, o ] }
          choices.select { |c| v.include?(c.last) }.map(&:first).join(", ")
        end
      end
    end
  end
end