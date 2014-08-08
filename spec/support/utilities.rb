def full_title(pagename)
  "Ruby on Rails Tutorial Sample App" + ( pagename.empty? ? '' : " | #{pagename}" )
end
