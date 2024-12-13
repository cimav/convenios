class AgreementLogsController < ApplicationController
  before_action :set_agreement

  add_breadcrumb "Convenios", :agreements
  def index

    add_breadcrumb @agreement.title, agreement_path(@agreement)
    add_breadcrumb "Seguimiento", agreement_agreement_logs_path(@agreement)

    @logs = @agreement.agreement_logs.order(created_at: :desc) # Solo logs del acuerdo actual

    @logs = @logs.where(by_system: true) if params[:by_system] == "true"
    @logs = @logs.order(:created_at)

    #render partial: "agreement_logs/logs", locals: { logs: @logs }

  end

  def create
    @log = @agreement.agreement_logs.new(log_params)
    @log.owner = current_user
    @log.created_at = Time.now
    @log.status = @agreement.status

    if @log.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to agreement_agreement_logs_path(@agreement), notice: "Seguimiento agregado correctamente." }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "form_errors",
            partial: "shared/form_errors",
            locals: { resource: @log }
          )
        end
        format.html do
          @logs = @agreement.agreement_logs.order(created_at: :desc)
          render :index, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def set_agreement
    @agreement = Agreement.find(params[:agreement_id])
  end

  def log_params
    params.require(:agreement_log).permit(:message)
  end

end
