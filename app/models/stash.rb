class Stash < ActiveRecord::Base
  belongs_to :user
  belongs_to :title

  def Stash.stash_name(sid)
    sid = sid.to_s
    sname = case sid
            when "1" then "watched"
            when "2" then "now watching"
            when "3" then "to watch"
            else ""
            end
    return sname
  end
end
