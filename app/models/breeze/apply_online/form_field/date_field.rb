module Breeze
  module ApplyOnline
    module FormField
      class DateField < Base
        def to_html(form)
          form.date_select name, clean_options, options[:html] || {}
        end
        
        def value_for(view)
          y, m, d = %w(1i 2i 3i).collect { |p| (i = view.data[:"#{name}(#{p})"]).blank? ? nil : i.to_i }
          y && m && d && Date.new(y, m, d)
        end
        
        def hidden_fields_for(form)
          if v = value_for(form.object)
            form.template.hidden_field_tag("form[#{name}(1i)]", v.year) + 
            form.template.hidden_field_tag("form[#{name}(2i)]", v.month) +
            form.template.hidden_field_tag("form[#{name}(3i)]", v.day)
          else
            ""
          end
        end
        
        def output_value(view)
          if v = value_for(view)
            v.strftime("%e %B, %Y").strip
          else
            ""
          end
        end
      end
    end
  end
end