class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :signed_in?, :current_user?

  private

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user?(user)
    signed_in? && current_user == user
  end

  def require_signed_in_user
    if signed_in?
      @user = current_user
    else
      respond_to do |format|
        format.html {redirect_to signin_url}
        format.js { render text: 'alert("请登录")'}
      end
    end
  end

  def respond_to_ujs
    respond_to do |format|
      format.js
    end
  end

end
