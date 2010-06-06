module Breeze
  module ApplyOnline
    module FormField
      class TextField < StringField
        def field_html(form)
          form.text_area name, options.except(:default).reverse_merge(:rows => 4)
        end
      end
    end
  end
end