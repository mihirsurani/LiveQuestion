require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "only admin can delete user accounts" do
    session[:admin_prev] = true
    assert_difference('User.count', -1) do
      delete :destroy, :id => users(:one).id
    end
  end

=begin
  test "only admin can create other admin accounts" do
    #when admin is logged in, he can create a new admin user only.
    session[:admin_prev] = true
    post :create, user: {:userid => "aniadmin", :pwd => "aniadmin123", :email => "a@gmail.com", :permission =>"admin" }
    assert_equal(:notice,"Admin User was successfully created.")
  end
=end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: {:userid => "ani2", :pwd => "ani123", :email => "a@gmail.com", :permission =>"user" }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user.id
    assert_redirected_to  "/posts"
  end

end
