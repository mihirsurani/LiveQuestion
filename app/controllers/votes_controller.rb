class VotesController < ApplicationController
  # GET /votes
  # GET /votes.json
  def index
    @votes = Vote.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @votes }
    end
  end

  # GET /votes/1
  # GET /votes/1.json
  def show
    @vote = Vote.find(params[:id])

    respond_to do |format|
      format.html # results.html.erb
      format.json { render json: @vote }
    end
  end

  def post
    creator = Post.find(params[:id])
    creator_id = creator.userid
    if (creator_id == session[:user_id])
      respond_to do |format|
        format.html { redirect_to "/posts/#{params[:id]}", :notice => "You cannot vote to your own posts." }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    else
      user_id = User.find_by_userid(session[:user_id]).id
      prevvote = Vote.find_by_posts_id(params[:id],:conditions => "users_id = #{user_id}")
      if( prevvote.nil? )
        @vote =  Vote.new
        @vote.posts_id = params[:id]
        user = User.find_by_userid(session[:user_id])
        @vote.users_id = user.id
        respond_to do |format|
          if @vote.save
            format.html {redirect_to "/posts/#{params[:id]}"}# results.html.erb
            format.json { render json: @vote }
          else
            format.html { redirect_to "/posts/#{params[:id]}", :notice => "Vote was not successful" }
            format.json { render json: @vote.errors, status: :unprocessable_entity }
          end
        end
      else
        respond_to do |format|
          flash[:notice] = "You cannot vote to any post more than once."
          format.html { redirect_to "/posts/#{params[:id]}", :notice => "You cannot vote to any post more than once." }
          format.json { render json: @vote.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def reply
    creator = Post.find(params[:rep_id])
    creator_id = creator.userid
    if (creator_id == session[:user_id])
      respond_to do |format|
        flash[:notice] =  "You cannot vote to your own reply."
        format.html { redirect_to "/posts/#{params[:id]}", :notice=>"You cannot vote to your own reply." }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    else
      user_id = User.find_by_userid(session[:user_id]).id
      prevvote = Vote.find_by_posts_id(params[:rep_id],:conditions => "users_id = #{user_id}")
      if( prevvote.nil? )
        @vote =  Vote.new
        @vote.posts_id = params[:rep_id]
        user = User.find_by_userid(session[:user_id])
        @vote.users_id = user.id
        respond_to do |format|
          if @vote.save
            format.html {redirect_to "/posts/#{params[:id]}"}# results.html.erb
            format.json { render json: @vote }
          else
            format.html { redirect_to "/posts/#{params[:id]}", :notice => "Vote was not successful" }
            format.json { render json: @vote.errors, status: :unprocessable_entity }
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to "/posts/#{params[:id]}", :notice => "You cannot vote to any reply more than once." }
          format.json { render json: @vote.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # GET /votes/1/edit
  def edit
    @vote = Vote.find(params[:id])
  end

  # POST /votes
  # POST /votes.json
  def create
    @vote = Vote.new(params[:vote])

    respond_to do |format|
      if @vote.save
        format.html { redirect_to @vote, notice: 'Vote was successfully created.' }
        format.json { render json: @vote, status: :created, location: @vote }
      else
        format.html { render action: "new" }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /votes/1
  # PUT /votes/1.json
  def update
    @vote = Vote.find(params[:id])

    respond_to do |format|
      if @vote.update_attributes(params[:vote])
        format.html { redirect_to @vote, notice: 'Vote was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /votes/1
  # DELETE /votes/1.json
  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to votes_url }
      format.json { head :ok }
    end
  end

  def newvote
      @post = Post.find_by_postid(params[:id])
      @vote = Vote.create()
      @vote.posts_id= @post.postid
      respond_to do |format|
      if @vote.save
        format.html { redirect_to @vote, notice: 'Vote was successfully created.' }
        format.json { render json: @vote, status: :created, location: @vote }
      else
        format.html { render action: "new" }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end
end
