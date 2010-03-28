require 'rubygems'
require 'nokogiri'
require 'open-uri'
here = File.dirname(__FILE__)
require here + 'lib/gamerankings'

Review.auto_migrate!
ReviewOutlet.auto_migrate!

systems_path = "#{here}/html/articles"
systems = Dir.open(systems_path).reject{|dir| dir =~ /^\.\.?$/}

systems.each do |system|
  pages = Dir.open("#{systems_path}/#{system}").reject{|dir| dir =~ /^\.\.?$/}
  pages.each do |page_file|
    puts page_file
    page = Nokogiri::HTML(open("#{systems_path}/#{system}/#{page_file}"))
    rows = page.css("div#main_col table.release").first.css("tr").reject do |tr| 
      tr.attributes["class"] and tr.attributes["class"].text=="head"
    end
    rows.each do |row|
      site_node, date_node, rating_node, ratio_node = row.css("td")

      id            = site_node.css("a").first.attributes["href"].text.match(/\/sites\/(\d+)/).to_a.last
      outlet        = site_node.css("a").text.strip
      discounted    = site_node.text.strip =~ /\*$/ ? true : false
      if date_node.text.strip =~ /^(\d{2}\/\d{2}\/)([10]\d)/
        date        = date_node.text.strip.sub(/^(\d{2}\/\d{2}\/)([10]\d)/,"#{$1}20#{$2}")
      elsif date_node.text.strip =~ /^(\d{2}\/\d{2}\/)([89]\d)/
        date        = date_node.text.strip.sub(/^(\d{2}\/\d{2}\/)([89]\d)/,"#{$1}19#{$2}")
      elsif date_node.text.strip =~ /^(\d{2}\/\d{2}\/)(36)/
        # there's one bad record for Indiana Jones and the Emporer's Tomb for XBox which
        # has it's release date set to the year 36. It's either a typo or someone having
        # a bit too much fun with the exploits of Indiana Jones.
        date        = date_node.text.strip.sub(/^(\d{2}\/\d{2}\/)(36)/,"#{$1}2003")
      else
        raise "DATE FAIL on #{date_node.text.strip}"
      end
      rating_string = rating_node.text.strip
      if rating_string =~ /out of/
        full_match, rating, scale = rating_string.match(/^([\d.]+) out of (\d+)$/).to_a
        raise ArgumentError, "Rating or Scale didn't exist in '#{rating_string}'" unless rating and scale
      elsif rating_string =~ /[A-Fa-f][+-]?/
        rating = rating_string.match(/[A-Fa-f][+-]?/).to_a.first
        scale  = "Letter Grade"
      else
        raise StandardError, "can't parse '#{rating_string}' into a rating"
      end
      ratio  = ratio_node.text.strip.sub(/%/,"")
      
      unless review_outlet = ReviewOutlet.first(:id=>id, :name=>outlet)
        puts "Couldn't find #{outlet}, creating record"
        review_outlet = ReviewOutlet.create(:id=>id, :name=>outlet)
      end
      
      if review = Review.first(:review_outlet_id => id, :game_id => page_file.match(/^\d+/).to_s)
        puts review
      else
        review = Review.new(
          :review_outlet_id => id, 
          :game_id => page_file.match(/^\d+/).to_s,
          :date => date,
          :rating => rating,
          :scale => scale,
          :ratio => ratio,
          :discounted => discounted
        )
        unless review.save
          raise review.errors.inspect
        end
      end
#      puts [id, outlet, date, rating, scale, ratio].inspect
    end
  end
end
