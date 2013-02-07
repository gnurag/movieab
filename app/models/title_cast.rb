class TitleCast < ActiveRecord::Base
  belongs_to :title
  belongs_to :person
end
