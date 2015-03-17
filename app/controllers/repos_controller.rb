class ReposController < ApplicationController
  before_action :require_signed_in_user

  def readme
    @content = @user.repos.find(params[:id]).readme.content
    respond_to_ujs
  end

end
