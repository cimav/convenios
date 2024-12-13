class DocumentsController < ApplicationController
  def destroy
    document = Document.find(params[:id])
    agreement = document.agreement
    if document.destroy
      flash[:notice] = "Documento eliminado correctamente."
      redirect_to agreement_path(agreement, anchor: 'document-form')
    else
      flash[:error] = "No se pudo eliminar el documento."
      redirect_to agreement_path(agreement, anchor: 'document-form')
    end
  end
end
