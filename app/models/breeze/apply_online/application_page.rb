module Breeze
  module ApplyOnline
    class ApplicationPage < Breeze::Content::PageView
      unloadable
      
      field :title

      attr_accessor :data
      cattr_accessor :form_fields do
        []
      end

      def populate(content, controller, request)
        # returning super do |view|
        # binding.pry
        super.tap do |view|
          view.data = load_data_from content, controller.session, request
          view.save_data_to controller.session
        end

      end
      
      def render!
        if request.post?
          if request.params[:next_button] && next?
            if valid?
              data[:_step] = self.next.name
              save_data_to controller.session
              unless self.next.next?
                application = form.application_class.factory(self)
                application.save
              end
              controller.redirect_to form.permalink and return false
            end
          elsif request.params[:back_button] && previous?
            data[:_step] = self.previous.name
            save_data_to controller.session
            controller.redirect_to form.permalink and return false
          end
        end
        
        super
      end

      def form
        content
      end

      def step
        _index + 1
      end
      
      def next?
        step < form.views.count
      end
      
      def next
        next? ? form.views[_index + 1] : nil
      end

      def previous?
        step > 1
      end

      def previous
        previous? ? form.views[_index - 1] : nil
      end
      
      def all_previous_steps
        form.views.select { |v| v._index < _index }
      end

      # def form_fields
      #   self.class.form_fields
      # end
      
      def data
        @data ||= {}
      end
      
      def all_fields
        @all_fields ||= ActiveSupport::OrderedHash.new.tap do |hash|
          form_fields.map(&:all_fields).flatten.each do |field|
            hash[field.name] = field
          end
        end
      end
      
      def all_fields_so_far
        @all_fields_so_far ||= ActiveSupport::OrderedHash.new.tap do |hash|
          all_previous_steps.each do |step|
            hash.merge! step.all_fields
          end
          hash.merge! all_fields
        end
      end

      def first
        form.views[0]
      end
      
      # def method_missing(sym, *args, &block)
      #   if field = all_fields_so_far[sym]
      #     field.value_for self
      #   elsif data.key? sym
      #     data[sym]
      #   elsif /^(\w+)\?$/ === sym.to_s && (field = all_fields_so_far[$1.to_sym])
      #     !data[sym].blank?
      #   elsif /^(\w+)_dependencies_met\?$/ === sym.to_s && (field = all_fields_so_far[$1.to_sym])
      #     field.dependencies_met?(self)
      #   else
      #     super
      #   end
      # end
      
      def self.field_group(name, options = {}, &block)
        form_fields << Breeze::ApplyOnline::FormField::Group.new(self, name, options, &block)
      end
      
      def variables_for_render
        super.merge! :form => self
      end
      
    protected
      def load_data_from(form, session, request)
        ((session[:form_data] && session[:form_data][form.id]) || {}).tap do |data|
          data.merge! request.params[:form] if request.params[:form].present?
        end.symbolize_keys
      end
      
      def save_data_to(session)
        session[:form_data] ||= {}
        session[:form_data][form.id] = data
      end
    end
  end
end