## Fetches latest movies from IMDb's nowplaying page and imports them to the DB.
## http://www.imdb.com/nowplaying/

require 'rubygems'
require 'nokogiri'
require 'open-uri'

## Settings
page       = "http://www.imdb.com/movies-in-theaters/"
req_params = {
  'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64; rv:2.0b11) Gecko/20100101 Firefox/4.0b11',
  'Referer' => "http://www.imdb.com/"
}
latest = []
curr_year = Time.now.year
## End settings

## Scraping the page
doc = Nokogiri::HTML(open( page, req_params ))
## xpath2: /html/body/div[3]/div[2]/layer/div[4]/div/table/tbody/tr[3]/td[2]/table/tbody/tr/td/a
doc.xpath('//h4[@itemprop="name"]/a').each do |t|
  title = t.text
  title.gsub!(/\(([^}]+)\)/,'')
  title.gsub!(/\ 3D$/, '')
  title.strip!

  Rails.logger.info "IMDb Movie: #{title}"
  movie = Title.find(:first, :conditions => ['title = ? and (release_year = ? or release_year = ?)', title, curr_year, curr_year - 1])
  if movie
    Rails.logger.info "ADDING: #{title}"
    latest.push(movie)
  else
    Rails.logger.error "ERROR: #{title} not found"
  end
end

## Adding selected titles to the DB.
UpcomingTitle.destroy_all if latest.length > 0
latest.uniq.each_with_index{|t,i|
  UpcomingTitle.create(:title_id => t.id, :sort_order => i, :enabled => true)
  t.sync_reset
  t.refresh_title_data
  sleep 1
}
