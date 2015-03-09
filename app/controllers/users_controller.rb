class UsersController < ApplicationController
  before_action :require_signed_in_user

  def show
  end

end
