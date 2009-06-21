class Sinatra::Twitto::User
  include DataMapper::Resource
  property  :id,         Serial
  property  :name,       String, :length => 256
  has n, :actions
  
  def fav(action)
    actions.each do |a|
      if a.id != action.id
        a.fav = false
      else
        a.fav = true
      end
    end
  end
end