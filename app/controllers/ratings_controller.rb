class RatingsController < ApplicationController
  before_action :expire_cache, only: [:create, :update, :destroy]
  before_action :skip_if_cached, only: [:index]

  def index
	#could still optimize db queries
	@top_beers = Rails.cache.fetch('top_beers', expires_in: 10.minutes) { Beer.top(3) }
	@top_breweries = Rails.cache.fetch('top_breweries', expires_in: 10.minutes) { Brewery.top(3) }
	@top_styles = Rails.cache.fetch('top_styles', expires_in: 10.minutes) { Style.top(3) }
	@most_active_users = Rails.cache.fetch('most_active_users', expires_in: 10.minutes) { User.most_active(3) }
	@recent_ratings = Rails.cache.fetch('recent_ratings', expires_in: 10.minutes) { Rating.recent }
	@ratings = Rails.cache.fetch('ratings', expires_in: 10.minutes) { Rating.includes(:user, :beer).all }
  end
  
  def new
    @rating = Rating.new
    @beers = Beer.all
  end
  
  def create
	@rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    if @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end
  
   def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end
  
  def expire_cache
	expire_fragement("ratingpage")
  end
  
  def skip_if_cached
    @order = params[:order] || 'name'
    return render :index if fragment_exist?( "ratingpage"  )
  end
end
