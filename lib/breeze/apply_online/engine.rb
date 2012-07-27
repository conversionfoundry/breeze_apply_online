module Breeze
  module ApplyOnline
    class Engine < ::Rails::Engine
      #include Breeze::Engine

      isolate_namespace Breeze::ApplyOnline


      config.to_prepare do
        ApplicationController.helper Breeze::ApplyOnline::ApplicationFormHelper
        Breeze::Content.register_class Breeze::ApplyOnline::ApplicationForm
  		end

    end
  end
end

