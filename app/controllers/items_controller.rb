class ItemsController < ApplicationController

  before_action :admin_user, only: [:new, :create, :destroy]
  before_action :signed_in_user, only: [:index, :checkout]

  def new
  	@item = Item.new
  end

  def create
  	@item = Item.new(item_params)
    if @item.save
      flash[:success] = "Item added successfully."
      redirect_to items_path
    else
      render 'new'
    end
  end

  def index
  	@items = Item.order(:category)
  	@unavailable_items = Item.where("available = ?", false)
  end

  def edit
  	@item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(item_params)
      flash[:success] = "Item updated"
      redirect_to items_url
    else
      render 'edit'
    end
  end

  def readd
  	@item = Item.find(params[:id])
  	if @item.update_attribute(:available, true)
      flash[:success] = "Item added to menu"
    end
    redirect_to items_url
  end

  def checkout
  	if params[:items].nil?
  		flash[:error] = "Select atleast one item to order."
  		redirect_to items_url
  	else
		@items = Item.find(params[:items].keys)
		@quantities = params[:items]

  	end
  end

  def destroy
  	Item.find(params[:id]).update_attribute(:available, false)
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
