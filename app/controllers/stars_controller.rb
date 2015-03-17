class StarsController < ApplicationController
  before_action :require_signed_in_user

  def index
    @tags = @user.tags
  end

end
