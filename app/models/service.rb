class Service < ApplicationRecord
  
  belongs_to :landing_page

  has_one_attached :image
  validates :title, presence: true 
  validates :description, presence: true
  

  after_create_commit do 
    broadcast_append_to landing_page,
      target: "services-stream-container",
      partial: "services/service",
      locals: { review: self }
  end

  after_destroy_commit do
    broadcast_remove_to landing_page
  end


end
