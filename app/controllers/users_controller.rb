class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy

  def index
    @title = "All users"
    #  @users = User.all # Show all User
    @users = User.paginate(:page => params[:page]) #Pagination
  end

  # Show User ID, name and e-mail
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
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
   # @user = User.find(params[:id])
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
 
  def destroy #destroy user
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

 
  private


    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
