require 'nokogiri'
require 'open-uri'

page_file = File.open("page_list.txt", "w")
url_base = "http://www.gamerankings.com"

here = File.dirname(__FILE__)
index_home = "#{here}/html/indexes"
index_dir = Dir.open(index_home)
indexes = index_dir.reject{|d| d =~ /^\.\.?$/}
indexes.each do |filename|
  page = Nokogiri::HTML open("#{index_home}/#{filename}")
  page.css("div#content div.body table a").each do |link|
    page_file << "#{url_base}#{link.attributes['href'].text}\n"
  end
end
