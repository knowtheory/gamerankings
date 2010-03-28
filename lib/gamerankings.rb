require 'rubygems'
require 'dm-core'
require 'dm-validations'
here = File.dirname(__FILE__)
require here + "/game.rb"
require here + "/review.rb"
require here + "/review_outlet.rb"

DataMapper.setup(:default, "mysql://localhost/gamerankings")
