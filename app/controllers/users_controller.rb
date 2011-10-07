class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      if(@user.permission == "user")
      format.html {redirect_to "/posts"}
      format.json { render json: @user }
      else
        format.html { render :action => "showadmin"} # results.html.erb
        format.json { render json: @user }
      end

    end
  end

  def showadmin
    respond_to do |format|
      format.html # showadmin.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user1 = User.find_by_userid(params[:user]["userid"])
    respond_to do |format|
      if @user1.nil?
        @user = User.new(params[:user])
        if session[:admin_prev].nil? or session[:admin_prev] == false
           @user.permission = "user"
        else
           @user.permission = "admin"
        end
        if @user.save
          if session[:admin_prev] == true
            @user = User.find_all_by_userid(session[:user_id])
            flash[:notice] = 'Admin User was successfully created.'
            format.html { redirect_to @user, notice: 'Admin User was successfully created.' }
            format.json { render json: @user, status: :created, location: @user }
          else
            if session[:user_id].nil?
              session[:user_id] = @user.userid
              session[:admin_prev] = false
              flash[:notice] = 'Guest User was successfully created.'
              format.html { redirect_to @user, notice: 'Guest User was successfully created.' }
              format.json { render json: @user, status: :created, location: @user }
            else
              @user = User.new
              @user.errors.clear
              @user.errors.add(" ","Cannot create User when logged in");
              flash[:notice] = 'Cannot create User when logged in'
              format.html { render action: "new"}
              format.json { render json: @user.errors, status: :unprocessable_entity }
            end
          end
        else
          @user = User.new
          @user.errors.clear
          @user.errors.add(" ","Problem creating users. ");
          format.html { render action: "new" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        @user = User.new
        @user.errors.clear
        @user.errors.add(" ","Username already Exists. Please choose another Username");
        flash[:notice] = 'User already exists.'
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    if( session[:admin_prev] == true)
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url }
        format.json { head  :ok }
      end
    else
      respond_to do |format|
       format.html { redirect_to users_url }
       format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def signout
    session[:user_id] = nil
    session[:admin_prev] = false

    respond_to do |format|
      format.html # signout.html.erb
      format.json { render json: @user }
    end
  end

  def validate_user
    user = User.find_by_userid(params[:id])
    if user.nil? then
      valid = "true"
    else
      valid = "false"
    end
    respond_to do |format|
      format.js { render :json => valid }
    end
  end

  def validate_login
    @user = User.find_by_userid(params[:username])
    session[:user_id] = nil
    session[:admin_prev] = false
    respond_to do |format|
      if  !@user.nil? and User.authenticate(params[:username],params[:password],params[:permission])
        if params[:permission] == "admin"
          session[:admin_prev] = true
        end
        session[:user_id] = params[:username]
        format.html { redirect_to @user }
        format.json { render :json => @user }
      else
        @user = User.new
        @user.errors.clear
        @user.errors.add(" ","Either Username, Password or Permission is wrong. Please try again.");
        format.html { render :action =>"new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def statistics
    respond_to do |format|
      format.html # statistics.html.erb
      format.json { render json: @user }
    end
  end

end
