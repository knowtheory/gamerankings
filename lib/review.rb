class Review
  include DataMapper::Resource
  
  property :game_id,          Integer, :key => true
  property :review_outlet_id, Integer, :key => true
  property :date,             Date
  property :rating,           String
  property :scale,            String
  property :ratio,            Float
  property :discounted,       Boolean, :default => true
  property :system,           String
  
  belongs_to :review_outlet
  belongs_to :game
end
