module Breeze
  module ApplyOnline
    module FormField
      class RadioField < Base
        def to_html(form)
          form.radio_button_group name, options[:options], clean_options
        end
      end
    end
  end
end