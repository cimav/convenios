class MembersController < ApplicationController
  before_action :set_agreement

  def new
  end

  def create

    #Rails.logger.debug "Parámetros completos: #{params.inspect} <----- "
    #Rails.logger.debug "Parámetros technical_responsible_params: #{technical_responsible_params.inspect} <----- "

    member = @agreement.members.new(member_params)

    if member.save
      flash[:notice] = "Participante agregado correctamente."
      redirect_to agreement_path(@agreement, anchor: 'member-form')
    else

      flash[:alert_member] = member.errors.full_messages.to_sentence
      redirect_to agreement_path(@agreement, anchor: 'alert-member')
    end

  end

  def destroy

    #Rails.logger.debug "Método HTTP: #{request.method}"

    #Rails.logger.debug "Parámetros DESTROY: #{params.inspect} <----- ********** ** * * * * * ** * ** * * * * * *  ******* ----*******"

    member = @agreement.members.find(params[:id])

    if member.destroy
      #@technical_responsible = @agreement.technical_responsibles.new
      redirect_to agreement_path(@agreement, anchor: 'member-form'), notice: "Participante eliminado correctamente."
    else
      redirect_to agreement_path(@agreement, anchor: 'member-form'), alert: "Error al eliminar participante."
    end
  end


  private

  def set_agreement
    @agreement = Agreement.find(params[:agreement_id])
  end

  def member_params
    params.require(:member).permit(:agreement_id, :user_id, :profile, :notes)
  end


end
