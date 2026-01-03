class LandingPagesController < ApplicationController
  before_action :set_landing_page, only: %i[ show edit update destroy styles business_details copywriting services update_reviews ]

  # GET /landing_pages or /landing_pages.json
  def index
    @landing_pages = LandingPage.all
  end

  # GET /landing_pages/1 or /landing_pages/1.json
  def show
  end

  # GET /landing_pages/new
  def new
    @landing_page = LandingPage.new
  end

  # GET /landing_pages/1/edit
  def edit
  end

  # POST /landing_pages or /landing_pages.json
  def create
    @landing_page = LandingPage.new(landing_page_params)

    respond_to do |format|
      if @landing_page.save
        format.html { redirect_to @landing_page, notice: "Landing page was successfully created." }
        format.json { render :show, status: :created, location: @landing_page }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @landing_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /landing_pages/1 or /landing_pages/1.json
  def update
    respond_to do |format|
      if @landing_page.update(landing_page_params)
        format.html { redirect_to edit_landing_page_path(@landing_page), notice: "Landing page was successfully updated.", status: :see_other }
        format.turbo_stream
        format.json { render :show, status: :ok, location: @landing_page }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @landing_page.errors, status: :unprocessable_entity }
      end
    end
  end


  def update_reviews 
    reviews_url_param =  params.require(:landing_page).permit(:google_maps_url)
    if @landing_page.update!( google_maps_url: reviews_url_param[:google_maps_url])
      puts "the update_reviews action is called with #{reviews_url_param[:google_maps_url]} "
      puts " the landing page is #{@landing_page.business_details} "
      FetchReviewsJob.perform_later(@landing_page)
    else 
      puts "did not update the google maps for the landign apge "
    end
  end
    

  # DELETE /landing_pages/1 or /landing_pages/1.json
  def destroy
    @landing_page.destroy!

    respond_to do |format|
      format.html { redirect_to landing_pages_path, notice: "Landing page was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def styles
  end


  def business_details
  end

  def copywriting
  end

  def services
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_landing_page
      @landing_page = LandingPage.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def landing_page_params
      ### the controller only permit the flat keys that's is why 
      # we have destructed this json 
      params.expect(landing_page: [
        :title,
        { copywriting: { hero_section: [:heading, :subheading] } },
        { business_details: [:business_name, :business_description, :conversion_goal, :call_to_action, :target_audience, selling_points: [], keywords: []] },
        { styles: { colors: [:primaryColor, :secondaryColor ,:lightColor , :darkColor], fonts: [:primaryFont, :secondaryFont] } },
        :logo,
        :hero_video,
        :background_image
      ])
    end


end
