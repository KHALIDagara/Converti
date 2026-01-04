class LandingPage < ApplicationRecord
  after_initialize :set_defaults, if: :new_record?

  has_many :services
  has_many :reviews

  store_accessor :business_details, :business_name, :business_description, :keywords, :target_audience, :selling_points, :offer
  store_accessor :copywriting

  has_one_attached :hero_video
  has_one_attached :video_overlay_image
  has_one_attached :logo do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 100, 100 ]
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
    # the stupid business has to tell me what their true intent is what the fuck they are selling exaclty and why selling it
    # business_name : useless but they will give them sense they have something
    # business_description : this is what matters and hopefully it's below 6 lines
    # target_audiecne : what is their ideal client?
    # selling points : what makes them unique # this is very critical
    # offer : this object has details about the offer they are prompting and the price if it's available
    # the keywords are for google ads stuff
    self.business_details = {
      business_name: "",
      business_description: "",
      keywords: [],
      selling_points: [],
      offer: "",
      target_audience: ""
    }
  end
end
