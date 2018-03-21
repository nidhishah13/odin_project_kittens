class KittensController < ApplicationController
  before_action :authenticate_user, only: [:create, :update, :show, :destroy]
  before_action :correct_user,   only: [:update, :destroy]

  def index
    kittens = Kitten.all      
    render :json => @kittens.as_json( :except => [:created_at, :updated_at], 
                            :methods => [:likes_count] ) 
  end

  def show
    @kitten = Kitten.find(params[:id]) #if id not found then application controller record_not_found

    render :json => @kitten.as_json( :except => [:created_at, :updated_at],
                      :methods => [:likes_count, :liked_by_user], current_user: @current_user )
  end

  def new 
    @kitten = Kitten.new
  end

  def create
    @kitten = @current_user.kittens.build(kitten_params)
    if @kitten.save
      render :json => @kitten.as_json( :except => [:created_at, :updated_at] ) 
    else
      
      render json: {errors: @kitten.errors.full_messages }
      #render json: { errors: @kitten.errors.full_messages }, status: :bad_request
		end
  end

  def edit
    @kitten = Kitten.find(params[:id]) 
  end

  def update
    @kitten = Kitten.find(params[:id])
    if @kitten.update_attributes(kitten_params)
     
      render :json => @kitten.as_json( :except => [:created_at, :updated_at] )
      # Handle a successful update.
    else
      render json: { errors: @kitten.errors.full_messages }, status: :bad_request
    end
  end

  def destroy 
    Kitten.find(params[:id]).destroy
    render json: {status: "Kitten deleted"}, status: :ok
  end

  def likers 
    @kitten = Kitten.find(params[:id])
    if @kitten.likes.any?
      render :json => @kitten.likers.as_json(only: [:name])
      #render :json => @kitten.as_json( only: :[], methods: :liked_by_user)
    else
      render :json => {error: "No likes"}
    end
  end

  private

    def kitten_params
      params.require(:kitten).permit(:name, :age, :cuteness, :softness, :user_id)
    end

    def correct_user
      if Kitten.find(params[:id])
        @kitten = @current_user.kittens.find_by(id: params[:id])
        if @kitten.nil?
          render json: {status: "This is not your kitten"}, status: :bad_request 
        end
      else
        render json: {error: "Kitten not found"}, status: :not_found
      end 
    end

end