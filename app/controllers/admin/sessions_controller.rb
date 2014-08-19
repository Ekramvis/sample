class Admin::SessionsController < Admin::ApplicationController

  skip_before_filter :require_admin!

  def stop_impersonation
    @user = User.find(session[:impersonator_id])
    session[:user_id] = @user.id
    session[:impersonator_id] = nil
    redirect_to admin_root_path
  end

end