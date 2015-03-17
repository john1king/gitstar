class ReposController < ApplicationController
  before_action :require_signed_in_user

  def index
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
    respond_to_ujs
  end

  def readme
    @content = @user.repos.find(params[:id]).readme.content
    respond_to_ujs
  end

  def edit_tag
    @repo = @user.repos.find(params[:id])
    @tags = @repo.stars.find_by(user: @user).tags
    respond_to_ujs
  end

  def update_tag
    @repo = @user.repos.find(params[:id])
    star = @repo.stars.find_by(user: @user)
    old_tags = star.tags.map {|tag| [tag.name, tag]}.to_h
    @tags = params[:tag_names].split.map do  |name|
      old_tags.delete(name) || @user.tags.find_or_create_by(name: name).tap {|tag| star.tags << tag}
    end
    old_tags.each do |_,  tag|
      star.tags.delete(tag)
    end
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
`
