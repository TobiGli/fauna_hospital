class VaccinationReminderMailer < ApplicationMailer
  def reminder(email, vaccination_ids)
    @vaccinations = Vaccination.includes(:patient).where(id: vaccination_ids).order(next_due_at: :asc)
    mail(to: email, subject: "Recordatorio de vacunas próximas a vencer")
  end
end
