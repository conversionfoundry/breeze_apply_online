module Breeze
  module ApplyOnline
    module FormField
      class Text < Base
        attr_accessor :text
        
        def to_html(form)
          form.template.content_tag :li, form.template.content_tag(:p, options[:text].html_safe)
        end
        
        def output_html(view)
          "<tr><td colspan=\"2\"><p>#{options[:text]}</p></td></tr>"
        end
        
      end
    end
  end
end