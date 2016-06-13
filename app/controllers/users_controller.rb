class UsersController < ApplicationController
  
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  	@user = User.find_by(id: params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  	#binding.pry
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params) 
  	if @user.save
      UserMailer.account_activation(@user).deliver_now
  		flash[:info] = "Please check your email to activate your account."
  		redirect_to root_url
  	else
  		render 'new'
  	end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def destroy
    User.find_by(id: params[:id]).destroy
    flash[:successs] = "Users deleted"
    redirect_to users_url
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update_attributes(user_params)
      #handles a successful update
      flash[:success] = "Profile Successfully updated"
      redirect_to @user
    else
    render 'edit'
    end
  end  


  private

	  def user_params
	  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
	  end

  #before filters

  #confirms a logged-in user
  # unless logged_in?
      #store_location
      #flash[:danger] = "Please log in"
      #redirect_to login_url
    #end
  #end 

  #confirms the correct user
  def correct_user
    @user = User.find_by(id: params[:id])
    redirect_to(root_url)  unless current_user?(@user)
  end

  #confirms an admin user
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
