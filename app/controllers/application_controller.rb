class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :signed_in?, :current_user?, :highlight_search

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
        format.html {redirect_to login_url}
        format.js { render text: 'alert("请登录")'}
      end
    end
  end

  def respond_to_ujs(&blk)
    respond_to do |format|
      format.js &blk
    end
  end

  def highlight_search(record, field)
    if highlight_results
      h = highlight_results[record.id]
      return h[field].first if h && h[field]
    end
    record.instance_eval field
  end

  def highlight_results
    return unless @search_results
    @highlight_results ||= @search_results.inject({}) do |h, r|
      h[r['_id'].to_i] = r['highlight'] || {}
      h
    end
  end

end
