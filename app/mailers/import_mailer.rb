class ImportMailer < ApplicationMailer
  def import_completed(email, count)
    @count = count
    mail(to: email, subject: "Importación de pacientes finalizada")
  end
end
