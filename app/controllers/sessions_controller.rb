class SessionsController < ApplicationController

  def new
  end

  def create
    if env['omniauth.auth']
      @user = User.from_omniauth(env['omniauth.auth'])
      @errors = @user.errors
      @authenticated = @errors.blank?
    else
      @user = User.where('LOWER(email) = ?', params[:session][:email].downcase).first
      @authenticated = @user ? !!@user.authenticate(params[:session][:password]) : false
    end

    if !@user || !@authenticated
      if @errors.present?
        flash.now[:error] = "Invalid login credentials. #{@errors.full_messages.join('. ')}".html_safe
      else
        flash.now[:error] = "Invalid login credentials. Did you <a href='/password_resets/new'>forget your password?</a>".html_safe
      end
      render :new
    elsif @user.is_suspended?
      flash.now[:warning] = 'Your account is currently suspended. You cannot log in.'
      render :new
    else
      session[:user_id] = @user.id

      if @download_now
        redirect_to(root_path(download: true))
      else
        redirect_back_or_to(root_path)
      end
    end
  end

  def download_login
    @download_now = true
    create
  end

  def destroy
    reset_session
    redirect_to root_path
  end

end
