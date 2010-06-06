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
          %w(1i 2i 3i).collect { |p| form.hidden_field :"#{name}(#{p})" }.join
        end
      end
    end
  end
end