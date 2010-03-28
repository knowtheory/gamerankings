class ReviewOutlet
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :required => true
  
  has n, :reviews
  has n, :games, :through => :reviews
end
