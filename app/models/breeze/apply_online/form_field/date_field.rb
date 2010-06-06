module Breeze
  module ApplyOnline
    module FormField
      class DateField < Base
        def to_html(form)
          form.date_select name, clean_options, options[:html] || {}
        end
        
        def value_for(view)
          y, m, d = %w(1i 2i 3i).collect { |p| view.data[:"#{name}(#{p})"].try(:to_i) }
          y && m && d && Date.new(y, m, d)
        end
      end
    end
  end
end