class Contact < ApplicationRecord
	belongs_to :user
	validates :phone, presence: true, format: { with: /\A\d{10}\z/, message: "must be a 10-digit number" }
end
