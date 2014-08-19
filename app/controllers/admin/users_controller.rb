class Admin::UsersController < Admin::ApplicationController
  inherit_resources

  def index
    @users = User.order(sort_column + " " + sort_direction).page(params[:page])
  end

  def admins
    @users = User.admins.order(sort_column + " " + sort_direction).page(params[:page])
  end

  def impersonate
    @user = User.find(params[:id])
    session[:impersonator_id] = current_user.id
    session[:user_id] = @user.id
    redirect_to root_path
  end

end