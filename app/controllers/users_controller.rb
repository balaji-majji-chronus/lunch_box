class UsersController < ApplicationController

  before_action :signed_in_user, only: [:show, :index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update, :show]
  before_action :admin_user,     only: [:destroy, :addcredit, :editcredit]

  def new
  	@user = User.new
  end

  def index
  	@users = User.paginate(page: params[:page])
  end
  	
  def show
    @user = User.find(params[:id])
    @orders = @user.orders.paginate(page: params[:page])
    if :admin_user
    	@inprogress_orders = Order.inprogress_orders
  		@open_orders = Order.fresh_orders
  		@delivered_orders = Order.delivered_orders
  		@cancelled_orders = Order.cancelled_orders
  	end
  end
  	
  def create
  	@user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Lunch Box!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def addcredit
  	@user = User.find(params[:id])
  	credit = @user.credit + params[:user][:credit].to_i
  	if (Integer(params[:user][:credit]) rescue false) && @user.update_attribute(:credit, credit)
  		flash[:success] = "Added Credit amount of #{params[:user][:credit].to_i} to User: #{@user.name}. Total credit is #{@user.credit}"
  		redirect_to users_url
  	else
  		flash[:error] = "Please enter a valid amount."
  		render 'editcredit'
  	end
  end

  def editcredit
  	@user = User.find(params[:id])
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id]) || not_found
      redirect_to User.find(current_user.id) if !current_user.admin? and !current_user?(@user)      	 
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
