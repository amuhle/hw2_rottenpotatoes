class Movie < ActiveRecord::Base
  
  def self.ordered_movies(criteria)
    Movie.order(criteria)
  end

  def self.ratings
    %w[G PG PG-13 R]
  end

  def self.with_ratings(ratings)
      Movie.where(:rating => ratings)
  end

end
