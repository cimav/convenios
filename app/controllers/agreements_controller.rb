class AgreementsController < ApplicationController

  # Agregar breadcrumbs para las rutas principales
  add_breadcrumb "Convenios", :agreements

  before_action :set_agreement, only: [:show, :edit, :update, :validate, :return_for_review, :upload_document, :change_status]
  before_action :authenticate_user!
  before_action :set_breadcrumbs_for_edition, only: [:edit, :update]

  def index

    @agreements = Agreement.for_table(current_user)

    # Realiza una sola consulta a la base de datos externa para obtener los solicitantes
    # Esta consulta evita el problema del N+1
    creator_ids = @agreements.map(&:creator_id).compact # sin nils
    # User usa el scope default que solo carga 5 atributos
    @creators_on_agreements = User.where(clave: creator_ids.map { |id| format('%05d', id) }).index_by(&:clave)

  end

  def show
    add_breadcrumb @agreement.title, agreement_path(@agreement)

    # @agreement = Agreement.find(params[:id])
    #Rails.logger.debug "Agreement en Show: #{@agreement.inspect} <<------------ 0"
    #Rails.logger.debug "Responsables Técnicos: #{@agreement.technical_responsibles.inspect} <------------ 1"

    # en el show siempre tengo uno listo por si agrega
    #@technical_responsible = @agreement.technical_responsibles.build

    # en show tengo un documento listo
    #@agreement.documents.build # Para añadir nuevos documentos desde el formulario
    @document = @agreement.documents.build
    #@document = Document.new

    # Show con acceso basado en Rules
    @can_edit_agreement = can_edit_agreement?
    @can_manage_technicals = can_manage_technicals?
    @can_manage_documents = can_manage_documents?

  end

  def upload_document
    #Rails.logger.debug "Parámetros completos: #{params.inspect} <----- "
    #Rails.logger.debug "Parametros recibidos >>>>>>>>: #{document_params.inspect} |||| #{params[:id]} <<<<<<<<<<< "

    #@agreement = Agreement.find(params[:id])
    @document = @agreement.documents.new(document_params)

    if @document.save
      flash[:notice] = "Documento subido correctamente."
      redirect_to agreement_path(@agreement, anchor: 'document-form')
    else
      # Prepara los datos necesarios para la vista `show`
      #@documents = @agreement.documents # Asegúrate de tener los documentos cargados
      #flash.now[:alert] = "Error al subir el documento."
      #render :show, status: :unprocessable_entity #  422 Unprocessable Entity, que indica que los datos no pasaron las validaciones. Esto es importante para mantener estándares RESTful.

      # Alternativa. Redirigir con msgs flash. Queda mas limpio. pero el @document se renueva
      # pierdo los datos pero evito lo confuso de /agreements/9/upload_document
      # flash[:alert] = @document.errors.full_messages.to_sentence
      flash[:alert_document] = @document.errors.full_messages.to_sentence
      redirect_to agreement_path(@agreement, anchor: 'alert-document')
    end
  end

  def validate
    @agreement.validado!
    AgreementMailer.agreement_validated(@agreement).deliver_later
    redirect_to agreements_path, notice: "El acuerdo ha sido validado."
  end

  def return_for_review
    @agreement.devuelto!
    AgreementMailer.agreement_returned(@agreement).deliver_later
    redirect_to agreements_path, notice: "El acuerdo ha sido devuelto con comentarios."
  end

  def new

    @agreement = Agreement.new(client_type: 'persona_moral',
                               signature_date: Date.today, start_date: Date.today, end_date: Date.today + 1.month,
                               amount: 0.00, status: "pendiente")

    add_breadcrumb "Nuevo", '#'

  end

  def create

    @agreement = Agreement.new(agreement_params)
    @agreement.creator_id = current_user.id

    if @agreement.save

      AgreementLog.create(
        agreement: @agreement,
        status: :pendiente,
        owner_id: current_user.id,
        message: "Se crea convenio/contrato",
        by_system: true
      )

      flash[:notice] = "El acuerdo se creó correctamente."
      redirect_to agreement_path(@agreement) # Redirige a la vista de detalle del acuerdo
    else
      add_breadcrumb "Nuevo", '#'
      flash[:alert] = @agreement.errors.full_messages
      render :new, status: :unprocessable_entity , anchor: "alert-agreement" # Renderiza la vista 'new' si hay errores
    end

  end

  def edit
    #add_breadcrumb @agreement.title, agreement_path(@agreement)
    #add_breadcrumb "Edición", edit_agreement_path(@agreement)
  end

  def update
    if @agreement.update(agreement_params)
      flash[:notice] = "Los cambios se guardaron correctamente."
      redirect_to @agreement
      # render :edit
      #redirect_to edit_agreement_path(@agreement, anchor: "btn-save-agreement"), notice:  "Los cambios se guardaron correctamente."
    else
      flash[:alert] = @agreement.errors.full_messages #.to_sentence
      render :edit
      # redirect_to edit_agreement_path(@agreement, anchor: "btn-save-agreement")
    end
  end

  def update_status_deprecated
    agreement = Agreement.find(params[:id])
    new_status = params[:status]

    if agreement.can_change_status?(current_user, new_status)
      agreement.update!(status: new_status)
      flash[:notice] = "El estado se actualizó correctamente."
    else
      flash[:alert] = "No tienes permisos para realizar esta acción."
    end
    redirect_to agreement
  end

  # Acción para cambiar el estado del acuerdo
  def change_status

    new_status = params[:new_status]

    # Verifica si el usuario tiene permiso para cambiar el estado
    if @agreement.allowed_status_changes(current_user).include?(new_status)
      old_status = @agreement.status
      @agreement.update!(status: new_status)
      # Registro del cambio en AgreementLog
      AgreementLog.create!(
        agreement: @agreement,
        status: new_status,
        owner_id: current_user.id,
        message: "Status cambiado de #{Agreement.status_info(old_status)[:human]} a #{Agreement.status_info(new_status)[:human]}",
        by_system: true
      )
      flash[:notice] = "El estado fue cambiado exitosamente a #{Agreement.status_info(status)[:human]}."
    else
      flash[:alert] = "No tienes permiso para cambiar el estado."
    end

    # Redirigir de vuelta al acuerdo
    redirect_to agreements_path
  rescue ActiveRecord::RecordInvalid
    flash[:alert] = "No se pudo cambiar el estado. Por favor, inténtalo de nuevo."
    redirect_to @agreement
  end

  private

   def set_agreement
    @agreement = Agreement.find(params[:id])
  end

  def agreement_params
    params.require(:agreement).permit(:title, :agreement_type_id, :creator_id, :client_name, :client_address,
      :client_type, :witness_name, :witness_position, :objective, :obligations, :benefits,
      :signature_date, :start_date, :end_date, :amount, :signed_by_cliente, :signed_by_solicitante, :signed_by_director,
                                      :status, :code, :notes)
  end

  def document_params
    params.require(:document).permit(:document_type_id, :file, :notes)
  end

  def set_breadcrumbs_for_edition
    add_breadcrumb @agreement.title, agreement_path(@agreement)
    add_breadcrumb "Edición", edit_agreement_path(@agreement)
  end

  <<-RULES
    En el Show de Agreement.

    Regla 1: Si el status esta en :pendiente, todos los controles estan habilitados sin importar el :profile del usuario.

    Regla 2: Si el status No esta en :pendiente, solamente los usuarios con profile de :juridico pueden hacer todos los cambios.

    Regla 3: la excepcion de la regla 2 es cuando el status esta en :aprobado y el usuario es el creator o tiene profile de :solicitante. 
    En este caso el usuario puede subir y borrar documentos.

    De acuerdo a las 3 reglas, los controles a deshabilitar (o habilitar) son el boton de edicion de agreement, 
    los botones de eliminar tecnico, no agregar el tr de la form_with de tecnicos, deshabilitar el boton de eliminar 
    documento, y no poner el tr del form_with de documentos.

  RULES

  # Regla 1 y 2
  def can_edit_agreement?
    @agreement.pendiente? || current_user.juridico?
  end

  # Regla 1 y 2
  def can_manage_technicals?
    @agreement.pendiente? || current_user.juridico?
  end

  # Regla 1, 2 y 3
  def can_manage_documents?
    return true if @agreement.pendiente?
    return true if @agreement.aprobado? && (current_user == @agreement.creator || current_user.requester_of?(@agreement))
    current_user.juridico?
  end
end
