class UsersController < ApplicationController
  # Show User ID, name and e-mail
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  #Sign Up user
  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user]) 
    if @user.save #User Sign in
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else #Sign Up User
      @title = "Sign up"
      render 'new'
    end
  end

end

