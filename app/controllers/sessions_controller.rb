class SessionsController < ApplicationController

  def index
    render :new
  end

  def new
  end

  def create
    auth_hash = request.env['omniauth.auth']
    user = User.find_with_auth(auth_hash) || User.create_with_auth(auth_hash)
    session[:user_id] = user.id
    redirect_to root_url, notice: "Hi #{user.name}! You've signed in."
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "You've logged out!"
  end

  def failure
    redirect_to root_url, alert: "Sorry, but you didn't allow access to our app!"
  end
end
