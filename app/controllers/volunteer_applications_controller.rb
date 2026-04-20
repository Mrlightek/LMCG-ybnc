class VolunteerApplicationsController < ApplicationController
  before_action :set_volunteer_application, only: %i[ show edit update destroy ]

  # GET /volunteer_applications or /volunteer_applications.json
  def index
    @volunteer_applications = VolunteerApplication.all
  end

  # GET /volunteer_applications/1 or /volunteer_applications/1.json
  def show
  end

  # GET /volunteer_applications/new
  def new
    @volunteer_application = VolunteerApplication.new
  end

  # GET /volunteer_applications/1/edit
  def edit
  end

  # POST /volunteer_applications or /volunteer_applications.json
  def create
    @application = VolunteerApplication.new(volunteer_params)

    if @application.save
      redirect_to root_path, notice: "Application received! We'll be in touch."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /volunteer_applications/1 or /volunteer_applications/1.json
  def update
    respond_to do |format|
      if @volunteer_application.update(volunteer_application_params)
        format.html { redirect_to @volunteer_application, notice: "Volunteer application was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @volunteer_application }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @volunteer_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /volunteer_applications/1 or /volunteer_applications/1.json
  def destroy
    @volunteer_application.destroy!

    respond_to do |format|
      format.html { redirect_to volunteer_applications_path, notice: "Volunteer application was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def volunteer_params
    params.require(:volunteer_application).permit(
      :first_name, :last_name, :email, :phone,
      :city, :state, :why_join, :skills_description,
      :availability, :can_donate_time,
      skill_areas: []
    )
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_volunteer_application
      @volunteer_application = VolunteerApplication.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def volunteer_application_params
      params.fetch(:volunteer_application, {})
    end
end
