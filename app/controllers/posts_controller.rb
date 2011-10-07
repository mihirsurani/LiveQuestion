class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all(:conditions => "posts_id IS NULL")
    @posts.each do |post|
      trank = cal_rank_by_time(post.id)
      vrank = cal_rank_by_votes(post.id)
      replies = Post.find_all_by_posts_id(post.id)
      replyid = 0;
      time = DateTime.new(0,1,1,0,0)
      replies.each do |reply|
        if (reply.created_at > time)
          time = reply.created_at
          replyid = reply.id
        end
      end
      if(replyid == 0)
        rrank = trank
      else
        rrank = cal_rank_by_time(replyid)
      end
      post.weight =  4*trank+5*vrank+1*rrank
      post.save
      puts "Weights of each trank: "+trank.to_s+" vrank: "+ vrank.to_s + " rrank: "+ rrank.to_s
    end
    @posts = Post.all(:conditions => "posts_id IS NULL", :order => "weight DESC, created_at DESC")
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # results.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
    text = @post.posttext
    if text.empty?
      respond_to do |format|
        flash[:notice] = "Post text cannot be an empty string."
        @post = Post.new
        @post.errors.clear
        @post.errors.add(" ","Post text cannot be an empty string.");
        format.html { render action: "new"}
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    else
      respond_to do |format|
        if @post.save
          flash[:notice] = "Post created Successfully."
          format.html { redirect_to @post, notice: 'Post was successfully created.' }
          format.json { render json: @post, status: :created, location: @post }
        else
          flash[:notice] = "Post could not be created."
          format.html { render action: "new" }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post}
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :ok }
    end
  end

  # GET /posts/:id/reply

  def new_reply
    @post = Post.new
    @post.posts_id = params[:id]
    @post.posttext = params[:reply]
    @post.userid = session[:user_id]
    respond_to do |format|
      if @post.save
        format.html {redirect_to "/posts/#{params[:id]}"}
        format.json { render json: Post.find(params[:id]) }
      else
        format.html {redirect_to "/posts/#{params[:id]}", :notice => "Reply could not be saved"}
        format.json { render json: Post.find(params[:id]) }
      end
    end
  end

end
