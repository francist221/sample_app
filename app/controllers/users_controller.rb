class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]
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

  def edit # Edit User Page
    @user = User.find(params[:id])
    @title = "Edit user"
  end

  def update #Update User in database
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  private

    def authenticate
      deny_access unless signed_in?
    end

end

