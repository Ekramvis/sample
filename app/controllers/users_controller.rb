class UsersController < ApplicationController

  before_filter :require_user!, except: [ :new, :create, :download_signup, :show ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.welcome(@user).deliver
      session[:user_id] = @user.id
      flash[:success] = 'Thanks for joining! Your account has been created.'

      if @download_now
        redirect_to root_path(download: true)
      else
        redirect_to root_path
      end
    else
      flash.now[:error] = 'Please correct the errors below.'
      render :new
    end
  end

  def download_signup
    @download_now = true
    create
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      flash[:success] = 'Your settings have been updated.'
      redirect_to user_path(current_user)
    else
      flash.now[:error] = 'Please correct the errors below.'
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def settings
    @user = current_user
    render :show
  end

  def clear_notifications
    Towncry.mark_read_for(current_user)
    redirect_to questions_path
  end


  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :organization, :knowledge_level, :photo, :receive_notifications)
  end

end
