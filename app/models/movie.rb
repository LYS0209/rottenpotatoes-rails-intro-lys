class Movie < ActiveRecord::Base
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
  
  # My code
  def self.all_ratings
    @all_ratings = self.select('DISTINCT rating').map(&:rating)
  end
  
  def self.with_ratings(ratings_list)
    self.where({ rating: ratings_list})
  end
  # My code END
end
