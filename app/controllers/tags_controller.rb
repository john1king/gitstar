class TagsController < ApplicationController
  before_action :require_signed_in_user

  def create
    @tag = @user.tags.create!(name: params[:name])
    respond_to do |format|
      format.js
    end
  end

end
