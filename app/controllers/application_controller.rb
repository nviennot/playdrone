class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from Stretcher::RequestError::NotFound, :with => :render_404

  private

  def render_404
    render :file => "#{Rails.root}/public/404", :formats => [:html], :status => 404, :layout => false
  end
end
