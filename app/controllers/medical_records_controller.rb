class MedicalRecordsController < ApplicationController
  before_action :set_patient
  before_action :set_medical_record, only: %i[show]

  def index
    @medical_records = @patient.medical_records
  end

  def show
  end

  def new
    @medical_record = @patient.medical_records.build
  end

  def create
    @medical_record = @patient.medical_records.build(medical_record_params)

    if @medical_record.save
      redirect_to patient_medical_record_path(@patient, @medical_record),
                  notice: "Medical record was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def set_medical_record
    @medical_record = @patient.medical_records.find(params[:id])
  end

  def medical_record_params
    params.require(:medical_record).permit(
      :weight,
      :temperature,
      :diagnosis,
      :treatment_plan
    )
  end
end
