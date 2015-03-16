class TagsController < ApplicationController
  before_action :require_signed_in_user

  def new
    @tag = Tag.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @tag = @user.tags.create! tag_params
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @tag = @user.tags.find(params[:id])
    @tag.destroy
    respond_to do |format|
      format.js
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

end
