class ReposController < ApplicationController
  before_action :require_signed_in_user

  def readme
    @content = @user.repos.find(params[:id]).readme.content
    respond_to_ujs
  end

  private

  def page_params
    { page: fetch_int(:page, 1), per: [fetch_int(:per, 30), 100].min }
  end

  def fetch_int(key, default)
    value = params[key].to_i
    value.zero? ? default : value
  end

end
