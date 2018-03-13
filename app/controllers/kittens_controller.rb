class KittensController < ApplicationController

  def index
    @kittens = Kitten.all
  end

  def show
    @kitten = Kitten.find(params[:id])
  end

  def new 
    @kitten = Kitten.new
  end

  def create
    @kitten = Kitten.new(kitten_params)
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
    flash.now[:success] = "Kitten deleted"
		redirect_to root_url
  end

  private

    def kitten_params
      params.require(:kitten).permit(:name, :age, :cuteness, :softness)
    end

end
