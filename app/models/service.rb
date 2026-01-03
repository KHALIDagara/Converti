class Service < ApplicationRecord
  
  belongs_to :landing_page

  has_one_attached :image
  validates :title, presence: true 
  validates :description, presence: true
  

  # All updates handled by turbo_stream files (create/update/destroy.turbo_stream.erb)
  # No broadcasts needed - turbo_stream responses update both editor and canvas


end
