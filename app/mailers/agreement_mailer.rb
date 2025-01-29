class AgreementMailer < ApplicationMailer
  def agreement_validated(agreement)
    @agreement = agreement
    mail(to: @agreement.client.email, subject: "Su acuerdo ha sido validado")
  end

  def agreement_returned(agreement)
    @agreement = agreement
    mail(to: @agreement.client.email, subject: "Su acuerdo requiere ajustes")
  end

  default from: ENV["NOTIFICACIONES_EMAIL"] # Define el email remitente

  def log_notification(agreement, agreement_log)
    @agreement = agreement
    @agreement_log = agreement_log

    # Lista de destinatarios: creador, miembros y juridico
    # juridico_ids = RoleUser::ROLES[:juridico].map { |id| format('%05d', id) }
    juridico_ids = Role.where(role: :juridico).pluck(:user_id).map { |id| format('%05d', id) }
    juridico_emails = User.where(clave: juridico_ids).pluck(:email)
    recipients = (@agreement.members.map { |member| member.user.email } + [@agreement.creator.email] + juridico_emails).uniq

    if Rails.env.development?
      recipients = 'juan.calderon@gmail.com'
    end

    mail(
      to: recipients,
      subject: "Nuevo seguimiento en el acuerdo ##{@agreement.id}"
    )
  end

end
