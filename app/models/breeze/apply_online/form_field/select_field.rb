module Breeze
  module ApplyOnline
    module FormField
      class SelectField < Base
        def to_html(form)
          form.select name, options[:options], clean_options, options[:html] || {}
        end
      end
    end
  end
end