class SearchesController < ApplicationController
  # GET /searches
  # GET /searches.json
  require "json"
  def results
    str = params[:search_text]
    str = str.strip
    @results = Hash.new
    @user_posts = Post.find_all_by_userid(str, :conditions => "posts_id IS NULL");
    @results["userposts"] = Array.new(@user_posts)
    puts @user_posts.count
    allposts = Post.all
    posts = Array.new
    allposts.each do |p|
      post_text = p.posttext
      post_text.sub(str) do |method|
         posts << p
      end
    end
    @results["posts"] = Array.new(posts)
    h =  Hash.new
    h["a"]  = "anirudh"
    puts @results.keys
    respond_to do |format|
      format.html #results.html.erb
      format.json { render json: @results}
    end
  end
end
