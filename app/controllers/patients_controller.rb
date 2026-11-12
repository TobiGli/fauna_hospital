require "securerandom"

class PatientsController < ApplicationController
  before_action :set_patient, only: %i[show edit update destroy]

  def index
    @patients = Patient.all
  end

  def show
  end

  def new
    @patient = Patient.new
  end

  def create
    @patient = Patient.new(patient_params)

    if @patient.save
      redirect_to @patient, notice: "Patient was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @patient.update(patient_params)
      redirect_to @patient, notice: "Patient was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @patient.destroy!
    redirect_to patients_path, status: :see_other, notice: "Patient was successfully destroyed."
  end

  def import
    if params[:file].present?
      filename = "#{SecureRandom.uuid}-#{File.basename(params[:file].original_filename)}"
      file_path = Rails.root.join("tmp", filename)

      File.open(file_path, "wb") do |file|
        file.write(params[:file].read)
      end

      PatientImportJob.perform_later(file_path.to_s, current_user.email)
      redirect_to patients_path, notice: "La importación ha comenzado en segundo plano. Te notificaremos cuando termine."
    else
      redirect_to patients_path, alert: "Selecciona un archivo CSV para importar."
    end
  end

  private

  def set_patient
    @patient = Patient.find(params[:id])
  end

  def patient_params
    params.require(:patient).permit(
      :identifier,
      :name,
      :species_id,
      :admission_date,
      :status,
      custom_metrics: {}
    )
  end
end
