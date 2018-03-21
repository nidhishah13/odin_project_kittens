class UsersController < ApplicationController

  def create 
    user = User.new(user_params)

    if user.save
      render json: {status: 'User created uccessfully'}, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end

  def login
    user = User.find_by(email: params[:email].to_s.downcase)

    if user && user.authenticate(params[:password])
      auth_token = Knock::AuthToken.new payload: ({user_id: user.id})
      render json: {auth_token: auth_token.token}, status: :ok
    else
      render json: {error: 'Invalid username/password'}, status: :unauthorized
    end

  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
