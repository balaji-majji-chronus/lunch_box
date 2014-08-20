class OrdersController < ApplicationController

  before_action :signed_in_user, only: [:create, :destroy]

  def create
  	@items = Item.find(params[:items])
  	total = Item.total_price(@items)
  	balance = current_user.credit - total.to_i
 
  	if balance < 0
  		flash[:error] = "Insufficient credit balance."
  		redirect_to items_url
  		return
  	end

  	@order = current_user.orders.build()
    if @order.save
      @items.each do |item|
      	@orderedItem = @order.ordered_items.create(item_id: item.id)
      end	
      flash[:success] = "Order placed successfully!"
      current_user.update_attribute(:credit, balance )
      redirect_to current_user
    else
      redirect_to @items
    end
  end

  def destroy
  	@order = Order.find(params[:id])
  	@user = User.find(@order.user_id)
  	if @order.status
  		@order.destroy
  		flash[:success] = "Order deleted successfully."
  	else
  		total = OrderedItem.order_amount(@order.ordered_items)
  		credit = @user.credit
  		credit += total
  		@user.update_attribute(:credit, credit)
  		@order.destroy
  		flash[:success] = "Order cancelled successfully. Amount credited to your account."
  	end
  	redirect_to @user
  end

  
end
