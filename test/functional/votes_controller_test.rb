require 'test_helper'

class VotesControllerTest < ActionController::TestCase
  fixtures :posts
  test "user cannot vote his own reply" do
    session[:user_id] = posts(:tworeply).userid
    get :reply, :rep_id=>posts(:tworeply).id, :id=>posts(:tworeply).posts_id
    assert_equal(flash[:notice],"You cannot vote to your own reply.")
    assert_redirected_to "/posts/#{posts(:tworeply).posts_id}"
  end

  test "user cannot vote to post more than once" do
    session[:user_id] = posts(:tworeply).userid
    get :post, :id=>posts(:onepost).id
    get :post, :id=>posts(:onepost).id
    assert_equal(flash[:notice],"You cannot vote to any post more than once.")
  end

  test "user cannot vote his own post" do
    session[:user_id] = posts(:onepost).userid
    get :post, :id=>posts(:onepost).id
    assert_equal(flash[:notice],"You cannot vote to your own posts.")
    assert_redirected_to "/posts/#{posts(:onepost).id}"
  end

  test "user cannot vote to reply more than once" do
    session[:user_id] = posts(:onepost).userid
    get :reply, :rep_id=>posts(:tworeply).id, :id=>posts(:tworeply).posts_id
    get :reply, :rep_id=>posts(:tworeply).id, :id=>posts(:tworeply).posts_id
    assert_equal(flash[:notice],"You cannot vote to any reply more than once.")
  end

end
