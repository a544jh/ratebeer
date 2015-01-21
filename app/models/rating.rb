class Rating < ActiveRecord::Base
	belongs_to :beer
	
	def to_s
		return "#{beer.name} #{self.score}"
	end
end
