class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from(Stretcher::RequestError::NotFound) { head :not_found }
end
