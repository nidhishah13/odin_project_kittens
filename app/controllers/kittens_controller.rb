class KittensController < ApplicationController
  before_action :authenticate_request!, only: [:create, :update, :show, :destroy]
  before_action :correct_user,   only: [:update, :destroy]

  def index
    @kittens = Kitten.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @kittens.as_json( :except => [:created_at, :updated_at], 
                            :methods => [:likes_count, :my_kitten] ) }
    end
  end

  def show
    @kitten = Kitten.find(params[:id]) #if id not found then application controller record_not_found

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @kitten.as_json( :except => [:created_at, :updated_at],
                      :methods => [:likes_count, :my_kitten, :liked_by_user] ) }
    end
  end

  def new 
    @kitten = Kitten.new
  end

  def create
    @kitten = @current_user.kittens.build(kitten_params)
    if @kitten.save
			# flash.now[:success] = "Kitten created!"
      # redirect_to @kitten 
      render :json => @kitten.as_json( :except => [:created_at, :updated_at] ) 
    else
      respond_to do |format|
        format.html { 
          flash.now[:danger] = "Kitten not created"
          render 'new' }
        format.json { render :json => @kitten.errors.full_messages }
      end
      #render json: { errors: @kitten.errors.full_messages }, status: :bad_request
		end
  end

  def edit
    @kitten = Kitten.find(params[:id]) 
  end

  def update
    @kitten = Kitten.find(params[:id])
    if @kitten.update_attributes(kitten_params)
      # flash.now[:success] = "Kitten details updated"
      # redirect_to @kitten
      respond_to do |format|
        format.html {render text: "Kitten details updated" }
        format.json { render :json => @kitten.as_json( :except => [:created_at, :updated_at] ) }
      end
      # Handle a successful update.
    else
      render json: { errors: @kitten.errors.full_messages }, status: :bad_request
    end
  end

  def destroy 
    Kitten.find(params[:id]).destroy
    respond_to do |format|
      format.html {render text: "Kitten deleted" }
      format.json { render :json => "Kitten deleted" }
    end
  end

  private

    def kitten_params
      params.require(:kitten).permit(:name, :age, :cuteness, :softness, :user_id)
    end

    def correct_user
      @kitten = @current_user.kittens.find_by(id: params[:id])
      if @kitten.nil?
        render json: {status: "This is not your kitten"}, status: :bad_request 
      end
    end

end
