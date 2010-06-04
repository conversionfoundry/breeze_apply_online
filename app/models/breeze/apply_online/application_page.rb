module Breeze
  module ApplyOnline
    class ApplicationPage < Breeze::Content::PageView
      field :title

      validate :all_required_fields

      attr_accessor :data

      def populate(content, controller, request)
        returning super do |view|
          view.data = load_data_from controller.session, request
          view.save_data_to controller.session
        end
      end
      
      def render!
        if request.post?
          if request.params[:next_button] && next?
            if valid?
              data[:_step] = self.next.name
              save_data_to controller.session
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

      def form_fields
        @form_fields ||= define_form_fields
      end
      
      def data
        @data ||= {}
      end
      
      def method_missing(sym, *args, &block)
        if /^(\w+)_field$/ === sym.to_s
          define_form_field $1, *args, &block
        elsif field = form_fields.detect { |f| f.name == sym }
          field.value_for self
        elsif data.key? sym
          data[sym]
        elsif /^(\w+)\?$/ === sym.to_s && field = form_fields.detect { |f| f.name.to_s == $1 }
          !data[sym].blank?
        else
          super
        end
      end
      
      def variables_for_render
        super.merge! :form => self
      end

    protected
      def define_form_field(kind, name, options = {})
        klass = "Breeze::ApplyOnline::FormField::#{kind.to_s.camelize}Field".constantize
        klass.new name, options
      end
    
      def define_form_fields
        []
      end
      
      def load_data_from(session, request)
        returning((session[:form_data] && session[:form_data][form.id]) || {}) do |data|
          data.merge! request.params[:form] if request.params[:form].present?
        end.symbolize_keys
      end
      
      def save_data_to(session)
        session[:form_data] ||= {}
        session[:form_data][form.id] = data
      end
      
      def all_required_fields
        form_fields.select(&:required?).each do |field|
          next unless self.class.validators_on(field.name).empty?
          errors[field.name] << "cannot be blank" if field.value_for(self).blank?
        end
      end
    end
  end
end