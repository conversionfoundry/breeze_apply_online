module Breeze
  module ApplyOnline
    module FormField
      class TextField < StringField
        def to_html(form)
          form.text_area name, clean_options.reverse_merge(:rows => 4)
        end
      end
    end
  end
end