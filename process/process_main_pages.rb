require 'rubygems'
require 'nokogiri'
require 'open-uri'
here = File.dirname(__FILE__)
require here + 'lib/gamerankings'

systems_path = "#{here}/html/main"
systems = Dir.open(systems_path).reject{|dir| dir =~ /^\.\.?$/}

systems.each do |system|
  pages = Dir.open("#{systems_path}/#{system}").reject{|dir| dir =~ /^\.\.?$/}
  pages.each do |page_file|
    page = Nokogiri::HTML(open("#{systems_path}/#{system}/#{page_file}"))

    pods               = page.css("div#main_col div.content2 > div.pod")
    percent, rank_info = pods[0].css("div.body > table > tr > td")

    title              = page.css("h1").first.text
    crumbs             = page.css("div.crumbs a").map{|a|a.text}
    rank_info          = rank_info.text.split("\n").map{ |l| l.gsub(/\s+/," ").split(/:/).map{|t|t.strip} }
    overall_rank       = rank_info.assoc("Overall Rank").last
    percent            = percent.text.sub("%",'').to_f
    
    release_string     = page.text.match(/Release Date:([^\n]+)/).to_a.last.strip
    begin
      release_date     = Date.parse(release_string)
    rescue ArgumentError
      puts "Couldn't parse release date #{release_string}"
      release_date    = nil
    end
    
    game = Game.new(
      :id           => page_file.match(/\d+/).to_s,
      :name         => title,
      :ratio        => percent,
      :release_date => release_date,
      :overall_rank => overall_rank
    )
    
    unless game.save
      raise game.errors.inspect
    end
  end
end
