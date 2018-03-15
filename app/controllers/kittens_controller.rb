class KittensController < ApplicationController
  before_action :authenticate_request!, only: [:create, :update, :destroy]
  before_action :correct_user,   only: :update

  def index
    @kittens = Kitten.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @kittens }
    end
  end

  def show
    @kitten = Kitten.find(params[:id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @kitten }
    end
  end

  def new 
    @kitten = Kitten.new
  end

  def create
    @kitten = @current_user.kittens.build(kitten_params)
    if @kitten.save
			flash.now[:success] = "Kitten created!"
			redirect_to @kitten 
		else
			flash.now[:danger] = "Kitten not created"
			render 'new'
		end
  end

  def edit
    @kitten = Kitten.find(params[:id]) 
  end

  def update
    @kitten = Kitten.find(params[:id])
    if @kitten.update_attributes(kitten_params)
      flash.now[:success] = "Kitten details updated"
      redirect_to @kitten
      # Handle a successful update.
    else
      render 'edit'
    end
  end

  def destroy 
    Kitten.find(params[:id]).destroy
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => "Kitten deleted" }
    end
  end

  private

    def kitten_params
      params.require(:kitten).permit(:name, :age, :cuteness, :softness)
    end

    def correct_user
      @kitten = @current_user.kittens.find_by(id: params[:id])
      if @kitten.nil?
        render json: "cannot update" 
      end
    end

end
