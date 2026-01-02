class LandingPage < ApplicationRecord

  after_initialize :set_defaults, if: :new_record?

  has_many :services


  has_one_attached :hero_video
  has_one_attached :logo do |attachable| 
    attachable.variant :thumb, resize_to_limit: [100,100]
  end

  has_one_attached :background_image

  validates :styles, presence: true
  validates :copywriting, presence: true


  validates :title, presence: true


  private 


  def set_defaults 
    set_default_styles if styles.blank? 
    set_default_copywriting if copywriting.blank?
  end

  def set_default_styles 
    self.styles = { 
      colors: {
            primaryColor: "#000000",  
            secondaryColor: "#fffff"
      },
      fonts: {
         primaryFont: "sans",
         secondaryFont: "sans"
      }
    }
  end

  def set_default_copywriting
    self.copywriting = {
       hero_section: {
         heading: "Welcome To Our landing Page ",
         subheading: "Here you find very interesting stuff"
       }
    }
  end


  def set_default_business_details
    self.business_details = {
      business_name: "",
      business_description: "",
      selling_points: [],
      keywords: []
    }
  end
end
