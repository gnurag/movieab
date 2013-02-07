class AwardNomination < ActiveRecord::Base
  belongs_to :award
  belongs_to :title
  belongs_to :person
end
