class YoutubeVideo < ActiveRecord::Base

  def self.populate_videos(title)
    ytclient = YouTubeIt::Client.new(:dev_key => MovieAB::Youtube::API_KEY)
    search_string = title.title + " trailer"
    
    youtube_results   = nil
    begin
      ## Setting this flag just before searching videos to avoid race condition. 
      ## Youtube search takes some time, and if two concurrent requests get triggered,
      ## then we are left with several duplicate results.
      title.yt_synced = true
      title.save
      youtube_results = ytclient.videos_by(:query => search_string, :per_page => 4)
      if youtube_results and youtube_results.videos and youtube_results.videos.length > 0
        youtube_results.videos.each{|v|
          yv = YoutubeVideo.new
          yv.title_id = title.id
          yv.youtube_id = self.get_video_id(v.player_url)
          yv.player_url = v.player_url
          yv.url = self.get_embeddable_video(v.media_content)
          yv.duration = v.duration
          yv.video_title = v.title
          yv.description = v.description
          yv.video_id = v.video_id
          yv.view_count = v.view_count
          yv.author_uri = v.author.uri if v.author
          yv.author_name = v.author.name if v.author
          yv.save
        }
      end
    rescue Exception => e
      Rails.logger.error e
    end
  end

  def self.get_video_id(player_url)
    ytparams = CGI.parse(URI.parse(player_url).query)
    return ytparams['v'] if ytparams
  end

  def self.get_embeddable_video(media_content)
    v = media_content.detect{|m| m.default}
    return v.url if v
  end

  ## Returns new youtube embed url for use with HTML5 compatible browsers in an IFrame.
  def embed_url
    return "http://www.youtube.com/embed/#{youtube_id}"
  end
end
