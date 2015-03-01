class BeerClub < ActiveRecord::Base
	has_many :memberships
	has_many :users, through: :memberships
	has_many :confirmed_memberships, -> { where confirmed: true }, class_name: "Membership"
	has_many :members, through: :confirmed_memberships, source: :user
	has_many :applications, -> { where confirmed: false }, class_name: "Membership"
	has_many :applicants, through: :applications, source: :user
end
