class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all # include all helpers, all the time

  helper_method :cal_rank_by_time
  def cal_rank_by_time(id)
    post = Post.find(id)
    Time.zone_default = 'Eastern Time (US & Canada)'
    dt =  post.created_at
    days = DateTime.now.day - dt.day
    months = DateTime.now.month - dt.month
    if days < 0
      months = months - 1
      days = 31 - dt.day + DateTime.now.day
    end
    currentmin = DateTime.now.hour * 60 + Time.now.min
    createdmin = dt.hour * 60 + dt.min
    min = currentmin - createdmin
    if( min < 0)
      days = days -1
      min = (24*60 - createdmin) + currentmin
    end
    rank = 0;
    if days == 0 and months == 0
      if min >= 0 and min <= 5
        rank = 20
      elsif min > 5 and min <= 15
        rank = 17
      elsif min > 15 and min <= 20
        rank = 15
      elsif min > 20 and min <=30
        rank = 13
      elsif min > 30 and min <= 60
        rank = 12
      elsif min > 60 and min <= 2*60
        rank = 11
      elsif min > 2*60 and min <= 4*60
        rank = 10
      elsif min > 4*60 and min <= 8*60
        rank = 8
      elsif min > 8*60 and min <= 24*60
        rank = 6
      end
    end
    if days > 0 and months == 0
      if days >= 1 and days <=3
        rank = 4
      elsif days > 3 and days <=7
        rank = 2
      elsif days > 7 and days <= 30
        rank = 1
      end
    end
    if months > 0
      rank = 0
    end
    rank
  end

  helper_method :cal_rank_by_votes
  def cal_rank_by_votes(id)
    puts id
    votes = Vote.find_all_by_posts_id(id)
    if votes.nil?
      return 0
    else
      vote = votes.count
    end
    rank = 0
    if vote == 0
      rank = 1
    elsif vote == 1
      rank = 4
    elsif vote == 2
      rank = 6
    elsif vote == 3
      rank = 8
    elsif vote >= 4 and vote <= 7
      rank = 12
    elsif vote >= 8 and vote <= 15
      rank = 14
    elsif vote > 15 and vote <= 30
      rank = 16
    elsif vote > 30 and vote <= 50
      rank = 18
    elsif vote > 50
      rank = 20
    end
    rank
  end

end