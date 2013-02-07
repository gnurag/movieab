class TitleUpc < ActiveRecord::Base
  set_table_name "title_upc"
  belongs_to :title
end
