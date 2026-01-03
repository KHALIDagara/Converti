class Review < ApplicationRecord
  belongs_to :landing_page

  has_one_attached :avatar
  validates :name, presence: true
  validates :content, presence: true


  after_create_commit do 
    broadcast_append_to landing_page,
      target: "reviews-stream-container",
      partial: "reviews/review",
      locals: { review: self }
  end

  after_destroy_commit do
    broadcast_remove_to landing_page
  end

end
