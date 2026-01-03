class Review < ApplicationRecord
  belongs_to :landing_page

  has_one_attached :avatar
  validates :name, presence: true
  validates :content, presence: true

end
