class AuthController < ApplicationController
  # POST /auth/register
  def register
    @user = User.new(user_params)

    if @user.save
      token = JwtService.encode(user_id: @user.id)
      render json: {
        user: { id: @user.id, email: @user.email, name: @user.name },
        token: token
      }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /auth/login
  def login
    # Get email and password from params, handling potential nesting
    auth_params = params[:auth].present? ? params[:auth] : params
    @user = User.find_by(email: auth_params[:email])

    if @user&.authenticate(auth_params[:password])
      token = JwtService.encode(user_id: @user.id)
      render json: {
        user: { id: @user.id, email: @user.email, name: @user.name },
        token: token
      }
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  private

  def user_params
    # Handle params that could be either directly at the top level or nested under 'auth'
    params_to_use = params[:auth].present? ? params[:auth] : params
    params_to_use.permit(:name, :email, :password, :password_confirmation)
  end
end
