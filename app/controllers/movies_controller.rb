class MoviesController < ApplicationController

	helper_method :sort_column, :sort_direction
	
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
		@all_ratings = Movie.all_ratings
		
		if params.has_key?(:sort)
			session[:sort] = sort_column 	
		else
			session[:sort] ||= 'title'
		end
		
		if params.has_key?(:direction)
			session[:direction] = sort_direction
		else 
			session[:direction] ||= 'desc'
		end
		
		if params.has_key?(:ratings) 
			session[:ratings] = ratings_filter 
		else
			session[:ratings] ||= @all_ratings
		end
			
		@selected_ratings = session[:ratings]
		@movies = Movie.order(session[:sort] + ' ' + session[:direction]).find_all_by_rating(session[:ratings])
		
		unless params.has_key?(:sort) && params.has_key?(:direction) && params.has_key?(:ratings)
			redirect_to movies_path(:sort => session[:sort], :direction => session[:direction], :ratings => session[:ratings])
		end
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
		Movie.column_names.include?(params[:sort])? params[:sort] : 'title'
	end

	def sort_direction
		%w[asc desc].include?(params[:direction])? params[:direction] : 'desc'
	end

	def ratings_filter
		if params[:ratings]
			(params[:ratings].class == Array)? params[:ratings] : params[:ratings].keys
		else
			@all_ratings
		end
	end
	
end
