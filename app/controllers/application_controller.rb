class ApplicationController < ActionController::API
  include Knock::Authenticable
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from ActiveRecord::RecordNotUnique, :with => :record_not_unique
  attr_accessor :current_user

  # protected
  
  #   # Validates the token and user and sets the @current_user scope
  #   def authenticate_request!
  #     if !payload || !JsonWebToken.valid_payload(payload.first)
  #       return invalid_authentication
  #     end

  #     load_current_user!
  #     invalid_authentication unless @current_user
  #   end

  #   # Returns 401 response. To handle malformed / invalid requests.
  #   def invalid_authentication
  #     render json: {error: 'Authentication failed'}, status: :unauthorized
  #   end

  private
  
    # Deconstructs the Authorization header and decodes the JWT token.
    # def payload
    #   auth_header = request.headers['Authorization']
    #   token = auth_header.split(' ').last
    #   JsonWebToken.decode(token)
    # rescue
    #   nil
    # end

    # # Sets the @current_user with the user_id from payload
    # def load_current_user!
    #   @current_user = User.find_by(id: payload[0]['user_id'])
    # end

    def record_not_found(error)
      render :json => {:error => 'Kitten not found'}, :status => :not_found
    end

    def record_not_unique(error)
      render :json => {:error => 'Record already exists'}, :status => :accepted
    end

end
