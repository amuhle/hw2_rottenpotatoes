class Movie < ActiveRecord::Base
  
  def self.ordered_movies(criteria)
    Movie.order(criteria)
  end

end
