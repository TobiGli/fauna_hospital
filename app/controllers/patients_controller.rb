require "csv"
require "json"

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
      CSV.foreach(params[:file].path, headers: true) do |row|
        species = Species.find_by(common_name: row["species_name"])

        Patient.create!(
          identifier: row["identifier"],
          name: row["name"],
          species: species,
          admission_date: row["admission_date"],
          status: row["status"],
          custom_metrics: JSON.parse(row["custom_metrics_raw"].to_s)
        )
      end

      redirect_to patients_path, notice: "Pacientes importados correctamente."
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
