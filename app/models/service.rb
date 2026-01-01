class Service < ApplicationRecord
  
  belongs_to :landing_page

  has_one_attached :image
  validates :title, presence: true 
  validates :description, presence: true
end
