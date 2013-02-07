class TitleGenere < ActiveRecord::Base
  belongs_to :title
  belongs_to :genere
end
