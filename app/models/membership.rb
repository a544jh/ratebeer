class Membership < ActiveRecord::Base
	belongs_to :user
	belongs_to :beer_club
	validates :beer_club_id, presence: true
	validates :user_id, uniqueness: { scope: :beer_club_id,
			message: "can only join a club once" },
		presence: true
end
