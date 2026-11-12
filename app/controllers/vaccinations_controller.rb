class VaccinationsController < ApplicationController
  before_action :set_patient
  before_action :set_vaccination, only: %i[show edit update destroy]

  def index
    @vaccinations = @patient.vaccinations.order(next_due_at: :asc)
  end

  def show
  end

  def new
    @vaccination = @patient.vaccinations.build(applied_at: Date.current)
    authorize @vaccination
  end

  def create
    @vaccination = @patient.vaccinations.build(vaccination_params)
    authorize @vaccination

    if @vaccination.save
      redirect_to @patient, notice: "Vacunación registrada correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @vaccination
  end

  def update
    authorize @vaccination

    if @vaccination.update(vaccination_params)
      redirect_to @patient, notice: "Vacunación actualizada correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @vaccination
    @vaccination.destroy!
    redirect_to patient_vaccinations_path(@patient), status: :see_other,
                                                      notice: "Vacunación eliminada correctamente."
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def set_vaccination
    @vaccination = @patient.vaccinations.find(params[:id])
  end

  def vaccination_params
    params.require(:vaccination).permit(
      :vaccine_name,
      :applied_at,
      :next_due_at,
      :dose,
      :notes
    )
  end
end
