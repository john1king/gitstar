class TagsController < ApplicationController
  before_action :require_signed_in_user

  def new
    @tag = Tag.new
    respond_to_ujs
  end

  def create
    @tag = @user.tags.create! tag_params
    respond_to_ujs
  end

  def edit
    @tag = @user.tags.find(params[:id])
    respond_to_ujs
  end

  def update
    @tag = @user.tags.find(params[:id])
    @tag.update(tag_params)
    respond_to_ujs
  end

  def destroy
    @tag = @user.tags.find(params[:id])
    @tag.destroy
    respond_to_ujs
  end

  def add_star
    @tag = @user.tags.find(params[:id])
    @star = @user.stars.find(params[:star_id])
    @tag.stars << @star unless @tag.stars.include? @star
    respond_to_ujs
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

end
