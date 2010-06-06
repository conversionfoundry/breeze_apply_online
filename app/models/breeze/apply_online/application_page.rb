module Breeze
  module ApplyOnline
    class ApplicationPage < Breeze::Content::PageView
      unloadable
      
      field :title

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

      def self.form_fields
        read_inheritable_attribute(:form_fields) || 
        write_inheritable_attribute(:form_fields, [])
      end
      def form_fields; self.class.form_fields; end
      
      def data
        @data ||= {}
      end
      
      def all_fields
        @all_fields ||= returning ActiveSupport::OrderedHash.new do |hash|
          form_fields.map(&:all_fields).flatten.each do |field|
            hash[field.name] = field
          end
        end
      end
      
      def method_missing(sym, *args, &block)
        if field = all_fields[sym]
          field.value_for self
        elsif data.key? sym
          data[sym]
        elsif /^(\w+)\?$/ === sym.to_s && (field = all_fields[$1.to_sym])
          !data[sym].blank?
        elsif /^(\w+)_dependencies_met\?$/ === sym.to_s && (field = all_fields[$1.to_sym])
          field.dependencies_met?(self)
        else
          super
        end
      end
      
      def self.field_group(name, options = {}, &block)
        form_fields << Breeze::ApplyOnline::FormField::Group.new(self, name, options, &block)
      end
      
      def variables_for_render
        super.merge! :form => self
      end
      
    protected
      def load_data_from(session, request)
        returning((session[:form_data] && session[:form_data][form.id]) || {}) do |data|
          data.merge! request.params[:form] if request.params[:form].present?
        end.symbolize_keys
      end
      
      def save_data_to(session)
        session[:form_data] ||= {}
        session[:form_data][form.id] = data
      end
      
      # def all_required_fields
      #   form_fields.select(&:required?).each do |field|
      #     next unless self.class.validators_on(field.name).empty?
      #     errors[field.name] << "cannot be blank" if field.value_for(self).blank?
      #   end
      # end
    end
  end
end