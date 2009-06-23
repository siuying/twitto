class Sinatra::Twitto::Action
  include DataMapper::Resource
  property  :id,     Serial
  property  :name,   String,  :length => 50
  property  :fav,    Boolean, :default => false
  belongs_to :user
  
end