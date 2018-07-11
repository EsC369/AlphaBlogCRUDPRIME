class UsersController < ApplicationController
  before_action :require_same_user, only: [:edit, :update]

  def index
    if !logged_in?
      flash[:danger] = "You must be logged in to access users!"
      redirect_to root_path
    else
      @users = User.paginate(page: params[:page], per_page: 5)
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome To The Alpah Blog #{@user.username}"
      redirect_to "/users/#{@user[:id]}/show"
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id]) # pulls the already exisiting info
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params) #white listing
        flash[:success] = "User was updated!"
        redirect_to articles_path
    else
        render "edit"
    end
  end

  def show
    @user = User.find(params[:id])
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def require_same_user
    @user = User.find(params[:id]) # Since this is a before action, you must reclarify youre instance variables
    if current_user != @user
      flash[:danger] = "You can only edit your own account"
      redirect_to root_path
    end
  end

end
