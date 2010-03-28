require 'rubygems'
here = File.dirname(__FILE__)
page_list = File.open("#{here}/../url_lists/sorted_pages.txt")
page_list.each_line do |link|
  junk, system, id = link.match(/http:\/\/www\.gamerankings\.com\/([^\/]+)\/(\d+)/).to_a
  FileUtils.mkdir_p("#{here}/../html/main/#{system}") unless File.exists?("./html/main/#{system}")
  `wget --output-document=#{here}/html/main/#{system}/#{id}.html --append-output=#{here}/../url_lists/main_page.log #{link}`
end
