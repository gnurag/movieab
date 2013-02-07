class InfoController < ApplicationController
  layout "info"

  def about; end
  def feedback; end
  def privacy; end
  def poweredby; end

  def xrds
    render :template => "info/xrds", :layout => false, :content_type => "application/xrds+xml"
  end
end
