require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  fixtures :posts
  fixtures :users

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "posts cannot be empty" do
    post :create, post: { :posttext => "", :userid => users(:one)}
    assert_equal(flash[:notice],"Post text cannot be an empty string.")
  end

  test "should allow any user to see posts" do
    session[:user_id] = nil
    get :index
    assert_response :success
  end

end
