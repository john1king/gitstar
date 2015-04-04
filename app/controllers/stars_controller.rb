class StarsController < ApplicationController
  before_action :require_signed_in_user
  helper_method :highlight

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
    result = Star.search(@user.id, params[:q], page_params)
    @stars = result.records.includes(:user, :repo, :tags)
    @results = result.results
    next_page_url(@results.total, action: :search, q: params[:q])
    respond_to_ujs { render 'index.js' }
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
    next_page_url(total, action: :index)
    render 'index.js'
  end

  def next_page_url(total, options = {})
    pages = page_params
    if (@page = pages[:page]) * pages[:per] < total
      pages[:page] += 1
      pages[:format] = :js
      pages.merge! options
      @next_page_url = url_for(pages)
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

  def highlight(star, field)
    if highlight_results
      h = highlight_results[star.id]
      return h[field].first if h && h[field]
    end
    star.instance_eval field
  end

  def highlight_results
    return unless @results
    @highlight_results ||= @results.inject({}) do |h, r|
      h[r['_id'].to_i] = r['highlight'] || {}
      h
    end
  end

end
