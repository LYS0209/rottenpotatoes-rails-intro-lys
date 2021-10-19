class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    @need_redirect_ratings = false
    @need_redirect_order = false
    
    if params.key?(:ratings)
      @ratings_to_show = params[:ratings].keys
    elsif session[:ratings]
      @ratings_to_show = session[:ratings]
      @need_redirect_ratings = true
    else
      @ratings_to_show = @all_ratings
    end
    session[:ratings] = @ratings
    @movies = Movie.with_ratings(@ratings_to_show)
    
    if params.key?(:orderBy)
      @order = params[:orderBy]
      session[:order] = @order
    elsif session[:order]
      @order = session[:order]
      @need_redirect_order = true
    end
    if @order == 'title'
      @movies = Movie.with_ratings(@ratings_to_show).order('title')
    elsif @order == 'release_date'
      @movies = Movie.with_ratings(@ratings_to_show).order('release_date')
    end
    
    if @need_redirect_order and @need_redirect_ratings
      redirect_to movies_path(:ratings => @ratings_to_show.map{ |x| [x, 1] }.to_h, :order => @order)
      return
    elsif @need_redirect_order
      redirect_to movies_path(:order => @order)
      return
    elsif @need_redirect_ratings
      redirect_to movies_path(:ratings => @ratings_to_show.map{ |x| [x, 1] }.to_h)
      return
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
