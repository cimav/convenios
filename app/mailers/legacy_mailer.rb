# frozen_string_literal: true

class LegacyMailer < ApplicationMailer

  before_action :set_xoauth2_token

  default from: "Notificaciones CIMAV <notificaciones@cimav.edu.mx>"

  def reenvio_mail_from_legacy(params_hash)
    attachments_array = params_hash[:attachments] || []

    @body = params_hash[:body]

    mail(to: params_hash[:to], subject: params_hash[:subject], reply_to: params_hash[:reply_to]) do |format|
      format.html { render html: @body.html_safe }

      attachments_array.each do |att|
        next unless att[:filename] && att[:content]

        attachments[att[:filename]] = Base64.decode64(att[:content])
      end
    end

  end

  private

  def set_xoauth2_token
    # REQUERIDO
    ActionMailer::Base.smtp_settings[:password] = generate_xoauth2_token(ENV["NOTIFICACIONES_EMAIL"])
  end


end
