class LikesController < ApplicationController
  before_action :authenticate_user, only: [:create, :destroy]

  def create
    begin
      @kitten = Kitten.find(params[:liked_id])
      if @current_user.likes.create(liked_id: @kitten.id)
        render json: {status: "Liked kitten"}, status: :created
      else
        render json: {error: 'An error occured' }, status: :bad_request
      end
    rescue ActiveRecord::RecordNotUnique
      render json: {error: "Already liked the kitten"}, status: :accepted
    end
  end

  def destroy
    if Kitten.find(params[:id])
      if like = Like.find_by(liked_id: params[:id], liker_id: @current_user.id )
        like.destroy
        render json: {status: "Unliked the kitten" }
      else
        render json: {status: "You have to like the kitten first" }, status: :bad_request
      end
    else
      render json: {errors: "Kitten not found"}
    end
  end

  # private
  
  #   def kitten
  #     @kitten = Kitten.find(params[:id])
  #   end

end
