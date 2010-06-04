module Breeze
  module ApplyOnline
    class ApplicationFormBuilder < Breeze::Admin::FormBuilder
      unloadable
      
      def current_step
        @object
      end
      
      def page
        @object.page
      end
      
      def steps
        step_list = page.views.collect do |step|
          state = case current_step.step <=> step.step
          when -1 then "pending"
          when  0 then "active"
          when  1 then "complete"
          end
          %{<li class="multipage-step-#{step.step} #{state}#{' first' if step.step == 1}#{' last' if step.step == page.views.count}"><span class="number">#{step.step}</span> <span class="title">#{step.title}</span></li>}
        end.join("\n")
        
        template.content_tag :div, "<ol>#{step_list}</ol>".html_safe, :class => "multipage-steps"
      end
      
      def fields
        field_contents = fieldset current_step.form_fields.collect { |field| field.to_html(self) }.join("\n")
        field_contents.gsub! /<fieldset><ol class="form">\s*<\/ol><\/fieldset>/, ""
        field_contents.html_safe
      end

      def back_button(label = "Back", options = {})
        template.submit_tag label, options.merge(:name => :back_button) if current_step.previous?
      end
      
      def next_button(label = "Next", options = {})
        label = options.delete(:finish) || "Finish" if current_step.next? && !current_step.next.next?
        template.submit_tag label, options.merge(:name => :next_button) if current_step.next?
      end
      
      def error_messages
        template.render "/breeze/apply_online/error_messages", :target => object, :object_name => :form
      end
    end
  end
end
