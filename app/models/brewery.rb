class Brewery < ActiveRecord::Base
	include RatingAverage
	
	def cannot_be_in_future
		if year.present? && year > Time.now.year
			errors.add(:year, "can't be in the future")
		end
	end
	
	def self.top(n)
		sorted_by_rating_in_desc_order = Brewery.all.sort_by{ |b| -(b.average_rating||0) }
		sorted_by_rating_in_desc_order[0..(n-1)]
	end

	has_many :beers, dependent: :destroy
	has_many :ratings, through: :beers
	
	scope :active, -> { where active:true }
    scope :retired, -> { where active:[nil,false] }
	
	validates :name, presence: true
	validates :year, numericality: { greater_than_or_equal_to: 1042,
                                    only_integer: true }
    validate :cannot_be_in_future
end
