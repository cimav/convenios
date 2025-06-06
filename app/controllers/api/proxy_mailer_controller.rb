# frozen_string_literal: true

class Api::ProxyMailerController < ApplicationController

  protect_from_forgery with: :null_session

  def re_send
    mail_data = params.require(:mail).permit(
      :to, :subject, :reply_to, :body,
      attachments: [:filename, :content]
    )

    legacyMailer = LegacyMailer.reenvio_mail_from_legacy(mail_data.to_h)
    legacyMailer.deliver_now

    render json: { status: "ok" }
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

end