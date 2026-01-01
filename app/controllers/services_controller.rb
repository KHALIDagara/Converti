class ServicesController < ApplicationController
  before_action :set_landing_page
  before_action :set_service, only: %i[ show edit update destroy ]

  # GET /services or /services.json
  def index
    @services = Service.all
  end

  # GET /services/1 or /services/1.json
  def show
  end

  # GET /services/new
  def new
    @service = @landing_page.services.build
  end

  # GET /services/1/edit
  def edit
  end

  # POST /services or /services.json
  def create
    @service = @landing_page.services.build(service_params)

    respond_to do |format|
      if @service.save
        format.html { redirect_to edit_landing_page_path(@landing_page), notice: "Service was successfully created." }
        format.turbo_stream
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /services/1 or /services/1.json
  def update
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to edit_landing_page_path(@landing_page), notice: "Service was successfully updated.", status: :see_other }
        format.turbo_stream
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1 or /services/1.json
  def destroy
    @service.destroy!

    respond_to do |format|
      format.html { redirect_to edit_landing_page_path(@landing_page), notice: "Service was successfully destroyed.", status: :see_other }
      format.turbo_stream
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_landing_page
      @landing_page = LandingPage.find(params.expect(:landing_page_id))
    end

    def set_service
      @service = @landing_page.services.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def service_params
      params.expect(service: [ :title, :description, :image, :landing_page_id ])
    end
end
