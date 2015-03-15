class ReposController < ApplicationController
  before_action :require_signed_in_user

  def index
    @repos = @user.repos
      .offset((page_params[:page] - 1)*page_params[:per])
      .limit(page_params[:per])
    if page_params[:page] * page_params[:per] < @user.stars_count
      @next_page_url = repos_url(page_params.dup.tap {|p| p[:page] += 1})
    end
    respond_to do |format|
      format.js
    end
  end

  def readme
    @content = @user.repos.find(params[:id]).readme.content
    respond_to do |format|
      format.js
    end
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
