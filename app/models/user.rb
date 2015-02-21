class User < ActiveRecord::Base
	include RatingAverage
	has_secure_password
	validates :username, uniqueness: true, length: { minimum: 3, maximum: 15 }
	validates :password, format: { with: /(?=.*[0-9])(?=.*[A-Z]).+/,
									message: "has to contain at least on number and upper-case letter" },
						 length: { minimum: 4 }
						
	has_many :ratings, dependent: :destroy   # käyttäjällä on monta ratingia
	has_many :beers, through: :ratings
	has_many :memberships
	has_many :beer_clubs, through: :memberships
	
	def favorite_beer
		return nil if ratings.empty?
		ratings.order(score: :desc).limit(1).first.beer
	end
	
	def favorite_style
		return nil if ratings.empty?
		styles = beers.select(:style_id).distinct
		max = styles.max_by {|st| ratings.joins(:beer).where("beers.style_id = ?", st.style_id).average(:score)}
		Style.find(max.style_id)
	end
	
	def favorite_brewery
		return nil if ratings.empty?
		breweries = beers.select(:brewery_id).distinct
		max = breweries.max_by {|br| ratings.joins(:beer).where("beers.brewery_id = ?", br.brewery_id).average(:score)}
		max.brewery	
	end
	
	def self.most_ratings(n)
		most_ratings = User.all.sort_by{ |u| -(u.ratings.count||0) }
		most_ratings.first(n)
	end
			
end
