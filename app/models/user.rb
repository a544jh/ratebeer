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
		styles = beers.select(:style).distinct
		styles.max_by do |st|
			ratings.joins(:beer).where("beers.style = ?", st).average(:score)
		end	
	end
			
end
