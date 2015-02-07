class SessionsController < ApplicationController

  def index
    render :new
  end

  def new
  end

  def create
    auth_hash = request.env['omniauth.auth']
    @authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
    if @authorization
      flash[:notice] = "Welcome back #{@authorization.user.name}! You have already signed up."
      user = @authorization.user
    else
      user = User.new :name => auth_hash["info"]["nickname"], :email => auth_hash["info"]["email"]
      user.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
      user.save
      flash[:notice] = "Hi #{user.name}! You've signed up."
    end
    session[:user_id] = user.id
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "You've logged out!"
  end

  def failure
    redirect_to root_url, alert: "Sorry, but you didn't allow access to our app!"
  end
end
