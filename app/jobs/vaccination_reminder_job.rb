class VaccinationReminderJob < ApplicationJob
  queue_as :default

  def perform
    vaccinations = Vaccination.includes(:patient).where(
      next_due_at: Date.current..30.days.from_now.to_date,
      reminder_sent_at: nil
    )
    return if vaccinations.empty?

    recipient_emails = User.where(role: %i[veterinarian admin]).pluck(:email)
    recipient_emails.each do |email|
      VaccinationReminderMailer.reminder(email, vaccinations.ids).deliver_later
    end

    vaccinations.update_all(reminder_sent_at: Time.current)
  end
end
