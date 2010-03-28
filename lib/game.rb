class Game
  include DataMapper::Resource
  
  property :id,           Serial
  property :name,         String, :length => 255
  property :release_date, Date
  property :overall_rank, String
  property :ratio,        Float
  
  has n, :reviews
  has n, :review_outlets, :through => :reviews
end
