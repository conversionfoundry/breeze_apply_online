# module Breeze
#   module ApplyOnline
#     class ApplicationFormBuilder < Breeze::Admin::FormBuilder
#       unloadable
      
#       def current_step
#         @object
#       end
      
#       def page
#         @object.page
#       end
      
#       def steps
#         step_list = page.views.collect do |step|
#           state = case current_step.step <=> step.step
#           when -1 then "pending"
#           when  0 then "active"
#           when  1 then "complete"
#           end
#           %{<li class="multipage-step-#{step.step} #{state}#{' first' if step.step == 1}#{' last' if step.step == page.views.count}"><span class="number">#{step.step}</span> <span class="title">#{step.title}</span></li>}
#         end.join("\n")
        
#         template.content_tag :div, "<ol>#{step_list}</ol>".html_safe, :class => "multipage-steps step-#{current_step.step}"
#       end
      
#       def fields
#         current_step.form_fields.collect { |field| field.to_html(self) }.join("\n").html_safe
#       end

#       def back_button(label = "Back", options = {})
#         template.submit_tag label, options.merge(:name => :back_button) if current_step.previous?
#       end
      
#       def next_button(label = "Next", options = {})
#         label = options.delete(:finish) || "Finish" if current_step.next? && !current_step.next.next?
#         template.submit_tag label, options.merge(:name => :next_button) if current_step.next?
#       end
      
#       def error_messages
#         template.render "/breeze/apply_online/error_messages", :target => object, :object_name => :form
#       end
      
#       def radio_button_group(method, choices, options = {})
#         choice_lis = choices.collect do |choice|
#           choice = [ Symbol === choice ? choice.to_s.humanize : choice.to_s, choice ] unless choice.is_a?(Array)
#           radio_button method, choice.last, :label => choice.first, :errors => false
#         end.join("\n").html_safe
#         choice_list = template.content_tag :ol, choice_lis
#         input = template.content_tag :fieldset, choice_list
#         options[:wrap] ||= {}
#         options[:wrap][:class] ||= "radio_button_group"
#         wrap method, input, options
#       end

#       def check_box_group(method, choices, options = {})
#         selected = Array(@object.send(method))
#         choice_lis = choices.collect do |choice|
#           choice = [ Symbol === choice ? choice.to_s.humanize : choice.to_s, choice ] unless choice.is_a?(Array)
#           "<li>" + template.check_box_tag("form[#{method}][]", choice.last, selected.include?(choice.last)) + " " + template.label_tag("form[#{method}][]", choice.first) + "</li>"
#         end.join("\n").html_safe
#         choice_list = template.content_tag :ol, choice_lis
#         input = template.content_tag :fieldset, choice_list
#         options[:wrap] ||= {}
#         options[:wrap][:class] ||= "check_box_group"
#         wrap method, input, options
#       end

#       def wrap(method, input, options)
#         contents = returning "" do |str|
#           str << label(method, options[:label], :required => options[:required]) unless options[:label] == false
#           str << wrap_field(input, options)
#           str << template.content_tag(:p, options[:hint], :class => "inline-hints") if options[:hint]
#           str << errors_for(method) if options[:errors] != false
#         end
#         template.content_tag :li, contents.html_safe, (options[:wrap] || {}).reverse_merge(:class => options[:kind])
#       end
      
#       def scripting
#         script = "$(function() {\n#{@object.all_fields.values.map(&:dependencies).flatten.map(&:script).join("\n")}"
#         if @object.all_fields.values.any? { |f| Breeze::ApplyOnline::FormField::MultiRowField === f }
#           script << <<-EOS
#             function renumberMultiRowField(selector) {
#               $(selector).each(function() {
#                 $('a.delete-row', this).toggle($('tbody tr', this).each(function(i) {
#                   $(':input', this).each(function() {
#                     $(this).attr('id', $(this).attr('id').replace(/_[0-9]+_/g, '_' + i + '_'));
#                     $(this).attr('name', $(this).attr('name').replace(/\\[[0-9]+\\]/g, '[' + i + ']'));
#                   });
#                 }).length > 1);
#               });
#             }
            
#             $('table.multi-row-field a.add-row').live('click', function() {
#               var t = $(this).closest('table');
#               var r = $('tbody tr', t).last();
#               r.clone().insertAfter(r).find('input[type=text]').val('');
#               renumberMultiRowField(t);
#               return false;
#             });

#             $('table.multi-row-field a.delete-row').live('click', function() {
#               var t = $(this).closest('table');
#               $(this).closest('tr').remove();
#               renumberMultiRowField(t);
#               return false;
#             });
            
#             renumberMultiRowField('table.multi-row-field');
#           EOS
#         end
#         script << "\n});"
#         template.javascript_tag script.html_safe, :defer => "defer"
#       end
      
#       def hidden_fields
#         unless ConfirmationPage === @object
#           @object.all_previous_steps.collect do |step|
#             step.all_fields.values.collect do |f|
#               f.dependencies_met?(@object) ? f.hidden_fields_for(self) : ""
#             end
#           end.flatten.join("\n").html_safe
#         end
#       end
      
#     protected
#       def filter_options(options)
#         super.except :before, :after, :message, :options, :wrap
#       end
#     end
#   end
# end
