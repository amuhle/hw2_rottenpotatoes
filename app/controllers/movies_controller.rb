class MoviesController < ApplicationController
  helper_method :sort_column, :selected_ratings

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if !valid_params || (params[:sort].nil? && params[:ratings].nil?)
      flash.keep
      redirect_to movies_path(ratings: selected_ratings, sort: sort_column)
    end
    save_params(params)
    @hilite_column = session[:sort]
    @ratings_keys = session[:ratings]
    @movies = Movie.with_ratings(@ratings_keys).order(session[:sort])
    @all_ratings = Movie.ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  private
  
  def sort_column
    session[:sort].nil? ? "title" : session[:sort]
  end
  
  def selected_ratings
    session[:ratings].nil? ? [] : session[:ratings]
  end

  def save_params(params)
    session[:ratings] ||= []
    session[:ratings] = ratings_to_array unless params[:ratings].nil?
    session[:sort] ||= "title"
    session[:sort] = params[:sort] if Movie.column_names.include?(params[:sort])
  end

  def valid_params
    valid = true
    unless params[:sort].nil? || Movie.column_names.include?(params[:sort])
      valid = false
      flash[:info] = "Sort column not found."
    end
    ratings_to_array.each do |r|
      unless Movie.ratings.include?(r)
        valid = false
        flash[:info] = "Rating option not found."
      end
    end
    valid
  end

  def ratings_to_array
    ratings_array =  params[:ratings] if params[:ratings].is_a?(Array)
    ratings_array ||= params[:ratings].keys unless params[:ratings].nil? 
    ratings_array ||= []
    ratings_array
  end
end
