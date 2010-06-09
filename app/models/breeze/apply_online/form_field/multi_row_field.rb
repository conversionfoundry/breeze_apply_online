module Breeze
  module ApplyOnline
    module FormField
      class MultiRowField < Base
        unloadable
        
        attr_accessor :subfields
        
        def initialize(page, name, options, &block)
          super page, name, options, &block
        end
        
        def subfields
          @subfields ||= []
        end
        
        def method_missing(sym, *args, &block)
          if /^(\w+_field)$/ === sym.to_s
            options = args.extract_options!
            options[:group] = self
            args << options
            subfields << "Breeze::ApplyOnline::FormField::#{$1.classify}".constantize.new(self, *args, &block)
          else
            super
          end
        end

        def value_for(view)
          v = view.data[name] || [{}]
          case v
          when Hash then v.to_a.sort_by { |a| a.first.to_i }.map(&:last)
          else v
          end
        end
        
        def to_html(form)
          table = returning "" do |str|
            str << "<table class=\"multi-row-field\" id=\"form_#{name}\">"
            str << "<thead><tr>" + subfields.collect { |f| form.template.content_tag :th, f.label }.join + "<th></th></tr></thead>"
            str << "<tbody>"
            value_for(form.object).each_with_index do |row, i|
              str << "<tr>"
              subfields.each do |f|
                str << "<td>#{f.options[:before]} "
                field_name = "form[#{name}][#{i}][#{f.name}]"
                field_value = row[f.name]
                str << case f
                when StringField then form.template.text_field_tag field_name, field_value
                when SelectField then form.template.select_tag field_name, form.template.options_for_select(f.options[:options], field_value)
                end
                str << " #{f.options[:after]}</td>"
              end
              str << "<td><a class=\"delete-row\" href=\"#\">&times;</a></td></tr>"
            end
            str << "</tbody>"
            str << "<tfoot><tr><td colspan=\"#{subfields.size + 1}\"><a class=\"add-row\" href=\"#\">Add more</a></td></tr></tfoot>"
            str << "</table>"
          end.html_safe
          form.wrap name, table, clean_options
        end
        
        def hidden_fields_for(form)
          ""
        end
        
        def output_value(view)
          returning "" do |result|
            result << "<table>"
            result << "<thead><tr>" + subfields.collect { |f| "<th>#{f.label}</th>" }.join + "</tr></thead>"
            value_for(view).each do |row|
              result << "<tr>"
              subfields.each do |f|
                result << "<td>#{f.options[:before]} "
                field_value = row[f.name]
                case f
                when StringField then result << (field_value || "")
                when SelectField then result << (Array(f.options[:options].detect { |o| Array(o).last == field_value } || f.options[:options].first).first || "")
                end
                result << " #{f.options[:after]}</td>"
              end
              result << "</tr>\n"
            end
            result << "</table>\n"
          end
        end

      end
    end
  end
end