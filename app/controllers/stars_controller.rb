class StarsController < ApplicationController
  before_action :require_signed_in_user

  def index
    respond_to do |format|
      format.html {
        @tags = @user.tags
      }
      format.js {
        load_stars
      }
    end
  end

  def search
    result = Star.search(params[:q], @user.id, page_params)
    @stars = result.records
    @stars = @stars.includes(:repo, :tags)
    next_page_url(result.results.total, q: params[:q])
    respond_to_ujs { render 'index.js'}
  end

  def edit_tag
    @star = @user.stars.find(params[:id])
    @tags = @star.tags
    respond_to_ujs
  end

  def update_tag
    @star = @user.stars.find(params[:id])
    @star.tags = tag_names.map do |name|
      @user.tags.find_or_create_by(name: name)
    end
    respond_to_ujs
  end

  private

  def load_stars
    if params[:tag_id]
      @tag = @user.tags.find(params[:tag_id])
      @stars = @tag.stars
      total = @tag.stars_count
    else
      @stars = @user.stars
      total = @user.stars_count
    end
    @stars =  @stars.offset((page_params[:page] - 1)*page_params[:per]).limit(page_params[:per])
    @stars = @stars.includes(:repo, :tags)
    next_page_url(total)
    render 'index.js'
  end

  def next_page_url(total, query = {})
    pages = page_params
    if (@page = pages[:page]) * pages[:per] < total
      pages[:page] += 1
      pages[:format] = :js
      pages.merge! query
      @next_page_url = stars_url(pages)
    end
  end

  def page_params
    { page: fetch_int(:page, 1), per: [fetch_int(:per, 30), 100].min }
  end

  def fetch_int(key, default)
    value = params[key].to_i
    value.zero? ? default : value
  end

  def tag_names
    params[:tags].split(',').map(&:strip).delete_if(&:empty?)
  end

end
