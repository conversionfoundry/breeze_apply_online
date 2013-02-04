require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "active_support/railtie"
require "sprockets/railtie"
require "carrierwave"
require "mongoid"
require "carrierwave/mongoid"
require "pry-rails"
require "cancan"
require "RMagick"
require "jquery-rails"
require "rdiscount"
require "execjs"
require "mongoid_fulltext"
require "haml"

module Breeze
  module ApplyOnline
    class Engine < ::Rails::Engine

      isolate_namespace Breeze::ApplyOnline


      config.to_prepare do
        ApplicationController.helper Breeze::ApplyOnline::ApplicationFormHelper
        Breeze::Content.register_class Breeze::ApplyOnline::ApplicationForm
  		end

    end
  end
end

