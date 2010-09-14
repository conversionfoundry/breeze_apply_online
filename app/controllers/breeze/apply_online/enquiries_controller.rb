module Breeze
  module ApplyOnline
    class EnquiriesController < Breeze::Admin::AdminController
      def index
        @enquiries = Breeze::ApplyOnline::Application.desc(:created_at).paginate :per_page => 20, :page => params[:page]
      end
      
      def show
        @enquiry = Breeze::ApplyOnline::Application.find params[:id]
        render :layout => "enquiry"
      end
      
    end
  end
end