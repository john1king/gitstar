class StarsController < ApplicationController
  before_action :require_signed_in_user

  def index
    @tags = @user.tags
    respond_to do |format|
      format.html
      format.js {
        load_stars
      }
    end
  end

  private

  def load_stars
    if params[:tag_id]
      @tag = @user.tags.find(params[:tag_id])
      stars = @tag.stars
      total = @tag.stars_count
    else
      stars = @user.stars
      total = @user.stars_count
    end
    stars =  stars.offset((page_params[:page] - 1)*page_params[:per]).limit(page_params[:per])
    @repos = Repo.includes(stars: :tags).find(stars.pluck(:repo_id))
     if (@page = page_params[:page]) * page_params[:per] < total
      @next_page_url = repos_url(page_params.dup.tap {|p| p[:page] += 1})
    end
    render 'index.js'
  end

  def page_params
    { page: fetch_int(:page, 1), per: [fetch_int(:per, 30), 100].min }
  end

  def fetch_int(key, default)
    value = params[key].to_i
    value.zero? ? default : value
  end

end
