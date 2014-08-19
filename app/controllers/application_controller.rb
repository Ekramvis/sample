require 'sir-trevor-rails'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :set_gon


  private

  def current_user
    @current_user ||= User.active.find_by_id(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def require_user!
    redirect_to_login unless current_user
  end

  def require_admin!
    redirect_to_login unless current_user.is_admin?
  end

  def redirect_to_login
    session[:redirect_to] = request.url
    flash[:warning] = 'You must login to access that page.'
    redirect_to login_path
  end

  def redirect_back_or_to to
    redirect_to(session[:redirect_to] || to)
    session[:redirect_to] = nil
  end

  def add_to_feed object
    FooterFeed.add object
  end

  def sort_column
    default_sort_column
  end
  helper_method :sort_column

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : default_direction_column
  end
  helper_method :sort_direction

  def default_sort_column
    'name'
  end

  def default_direction_column
    'asc'
  end

  def set_gon
    gon.started = true
  end

  def refresh_admin_queue
    Counter.refresh_stat(:admin_queue)
  end

end
