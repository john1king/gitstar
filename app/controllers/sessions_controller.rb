class SessionsController < ApplicationController

  def index
    if signed_in?
      redirect_to stars_url
    else
      render :new
    end
  end

  def new
  end

  def create
    auth_hash = request.env['omniauth.auth']
    user = User.find_with_auth(auth_hash) || User.create_with_auth(auth_hash)
    session[:user_id] = user.id
    StarredWorker.perform_async(user.id, auth_hash["credentials"]["token"])
    redirect_to stars_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "You've logged out!"
  end

  def failure
    redirect_to root_url, alert: "Sorry, but you didn't allow access to our app!"
  end
end
