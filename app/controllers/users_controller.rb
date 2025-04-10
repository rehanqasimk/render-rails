class UsersController < ApplicationController
  before_action :authenticate_user

  # GET /profile
  def profile
    render json: {
      user: {
        id: current_user.id,
        name: current_user.name,
        email: current_user.email
      }
    }
  end

  # PUT /profile
  def update
    if current_user.update(user_params)
      render json: {
        user: {
          id: current_user.id,
          name: current_user.name,
          email: current_user.email
        }
      }
    else
      render json: { errors: current_user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
