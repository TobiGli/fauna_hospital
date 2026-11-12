require "csv"
require "json"

class PatientImportJob < ApplicationJob
  queue_as :default

  def perform(file_path, user_email)
    imported_count = 0

    CSV.foreach(file_path, headers: true) do |row|
      species = Species.find_by(common_name: row["species_name"])

      Patient.create!(
        identifier: row["identifier"],
        name: row["name"],
        species: species,
        admission_date: row["admission_date"],
        status: row["status"],
        custom_metrics: JSON.parse(row["custom_metrics_raw"].to_s)
      )
      imported_count += 1
    end

    File.delete(file_path) if file_path && File.exist?(file_path)
    ImportMailer.import_completed(user_email, imported_count).deliver_later
  ensure
    File.delete(file_path) if file_path && File.exist?(file_path)
  end
end
