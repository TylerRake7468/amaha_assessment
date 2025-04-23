class Customer < ApplicationRecord
	validates	:user_id, :name, :latitude, :longitude, presence: true
	validates	:user_id, uniqueness: true
end
