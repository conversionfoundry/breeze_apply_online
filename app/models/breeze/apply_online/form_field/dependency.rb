module Breeze
  module ApplyOnline
    module FormField
      class Dependency
        unloadable
        
        attr_accessor :field_name
        attr_accessor :dependencies
        
        def initialize(field_name, dependencies = {})
          @field_name, @dependencies = field_name, normalize(dependencies || {})
        end
        
        def met?(view)
          dependencies.inject(true) do |result, (field_name, expected)|
            if result
              field = view.all_fields_so_far[field_name]
              if value = field.value_for(view)
                case expected
                when true then !value.blank?
                else value == expected
                end
              else
                false
              end
            else
              false
            end
          end
        end

        def normalize(d)
          returning({}) do |hash|
            Array(d).each do |a|
              case a
              when Symbol then hash[a] = true
              when String then hash[a.to_sym] = true
              when Array  then hash[a[0].to_sym] = a[1] || true
              end
            end
          end
        end

        def script
          dependencies.collect do |f, e|
            "var f = #{check_function(f, e).gsub(/\s+/, ' ')}; $(':input[name=form[#{f}]]').change(f).bind('input', f).change();"
          end.join("\n")
        end
        
      protected
        def check_function(f, e)
          cond = case e
          when true then "!= ''"
          else "== '#{e}'"
          end
          <<-EOS
            function() {
              if (this.type == 'radio' || this.type == 'checkbox') {
                if (this.checked) {
                  $('#form_field_wrapper_#{field_name}').toggle($(this).attr('value') #{cond});
                }
              } else {
                $('#form_field_wrapper_#{field_name}').toggle($(this).val() #{cond});
              }
            }
          EOS
        end
      end
    end
  end
end