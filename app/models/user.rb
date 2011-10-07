class User < ActiveRecord::Base
  has_many :post
  has_many :votes
  validates_presence_of :userid
  validates_uniqueness_of :userid
  validates :pwd, :length => {:minimum => 6}

  def self.authenticate(userid, password, permission)
    user = self.find_by_userid(userid)
    if !user.nil?
      if user.pwd != password  or user.permission != permission
        return nil
      end
    end
    user.id
  end

end
