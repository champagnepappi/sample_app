class SessionsController < ApplicationController
  before_action :is_logged_in, except: :destroy
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.activated? && user.authenticate(params[:session][:password])
      #log the user in and redirect to the user's show page
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
  def is_logged_in
    if current_user
      redirect_to root_url
      flash[:alert] = "You are currently logged in"
    end
  end
end
