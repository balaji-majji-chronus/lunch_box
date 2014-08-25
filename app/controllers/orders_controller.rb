class OrdersController < ApplicationController

  before_action :signed_in_user
  before_action :admin_user, only: [:take, :inprogress, :deliver]

  def create
  	@items = Item.find(params[:items])
  	@quantities = params[:quantities]
  	total = Item.total_order_cost(@items, @quantities)
  	balance = current_user.credit - total.to_i
 
  	if balance < 0
  		flash[:error] = "Insufficient credit balance."
  		redirect_to items_url
  		return
  	end

  	@order = current_user.orders.build()
    if @order.save
      @items.each do |item|
      	@orderedItem = @order.ordered_items.create(item_id: item.id, price: item.price, quantity: @quantities["#{item.id}"][:quantity])
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
  	@order.destroy
  	flash[:success] = "Order deleted from the history."
  	
  	redirect_to current_user
  end

  def take
  	@order = Order.find(params[:order])
  	if @order.update_attribute(:status, 1)
  		flash[:notice] = "Order is in progress."
  		redirect_back_or current_user
  	end
  end

  def inprogress
  	@inprogress_orders = Order.inprogress_orders
  end

  def deliver
  	@order = Order.find(params[:order])
  	if @order.update_attribute(:status, 2)
  		flash[:success] = "Order is placed."
  		redirect_back_or inprogress_url
  	end
  end

  def cancel
  	begin
  		@order = Order.find(params[:order])
  		@user = User.find(@order.user_id)
  		total = OrderedItem.order_amount(@order.ordered_items)
		credit = @user.credit
  		credit += total
  		@user.update_attribute(:credit, credit)
  		@order.update_attribute(:status, 3)
  		if current_user.admin
  			flash[:success] = "Order cancelled successfully. Amount credited to #{@user.name} account."
  		else
  			flash[:success] = "Order cancelled successfully. Amount credited to your account."
  		end
  		redirect_back_or current_user
  	rescue Exception => e  		  	
  		redirect_to current_user
  	end
  end

end
