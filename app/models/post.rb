class Post < ActiveRecord::Base
  belongs_to :user
  has_many :votes
  belongs_to :parent,:class_name => "Post"
  has_many :children,:class_name => "Post",:class_name => "Post",:foreign_key=>"posts_id",:dependent =>:destroy
  validates_presence_of :posttext

end
