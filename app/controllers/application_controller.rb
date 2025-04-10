class ApplicationController < ActionController::Base
  # Skip CSRF protection for API endpoints
  protect_from_forgery with: :null_session

  # Set JSON as the default response format
  before_action :set_default_format

  private

  def set_default_format
    request.format = :json unless params[:format]
  end

  def authenticate_user
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    begin
      @decoded = JwtService.decode(token)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
