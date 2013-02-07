# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def display_name(user)
    host = URI.parse(user[:openid_identity]).host
    name = (user[:name] and user[:name] != "") ? user[:name] : "Unknown"
    return "#{name} (#{host})"
  end

  def h_escape(str)
    str = str.gsub("'", "&#39;")
    str = str.gsub("\"", "&quot;")
    return str
  end

  def strip_html(str)
    return str.gsub(/<\/?[^>]*>/, "")
  end
end
