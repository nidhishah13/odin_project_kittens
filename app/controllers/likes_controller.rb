class LikesController < ApplicationController
  before_action :authenticate_request!, only: [:create, :destroy]

  def create
    @kitten = Kitten.find(params[:liked_id])
    if @current_user.likes.create(liked_id: @kitten.id)
      render json: {status: "Liked kitten"}, status: :created
    else
      render json: {error: 'An error occured' }, status: :bad_request
    end
  end

  def destroy
    @like = Like.find_by(liked_id: params[:id], liker_id: @current_user.id )
    @like.destroy
    render json: {status: "Unliked the kitten" }
  end

  # private
  
  #   def kitten
  #     @kitten = Kitten.find(params[:id])
  #   end

end
