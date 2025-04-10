class ApplicationController < ActionController::Base
  # Skip CSRF protection for API endpoints
  protect_from_forgery with: :null_session

  # Set JSON as the default response format
  before_action :set_default_format

  private

  def set_default_format
    request.format = :json unless params[:format]
  end
end
