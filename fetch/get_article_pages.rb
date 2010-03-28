require 'rubygems'
here = File.dirname(__FILE__)
page_list = File.open("sorted_pages.txt")
page_list.each_line do |link|
  junk, system, id = link.match(/http:\/\/www\.gamerankings\.com\/([^\/]+)\/(\d+)/).to_a
  FileUtils.mkdir_p("#{here}/../html/articles/#{system}") unless File.exists?("#{here}/../html/articles/#{system}")
  `wget --output-document=#{here}/../html/articles/#{system}/#{id}.html --append-output=article_page.log #{link.sub(/\/index.html$/,"/articles.html")}`
end
