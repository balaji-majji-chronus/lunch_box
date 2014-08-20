class ItemsController < ApplicationController

  before_action :admin_user, only: [:new, :create]
  before_action :signed_in_user, only: [:index, :checkout]

  def new
  	@item = Item.new
  end

  def create
  	@item = Item.new(item_params)
    if @item.save
      flash[:success] = "Item added successfully."
      redirect_to current_user_url
    else
      render 'new'
    end
  end

  def index
  	@items = Item.all
  end

  def checkout
  	if params[:items].nil?
  		flash[:error] = "Select atleast one item to order."
  		redirect_to items_url
  	else
		@items = Item.find(params[:items])
  	end
  end

  def destroy
  	Item.find(params[:id]).destroy
  	flash[:success] = "Item deleted."
  	redirect_to items_url
  end

  private

  	def item_params
      params.require(:item).permit(:name, :price, :category)
    end

  	def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
