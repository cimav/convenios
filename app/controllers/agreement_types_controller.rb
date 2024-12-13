class AgreementTypesController < ApplicationController

  before_action :set_agreement_type, only: [:show, :edit, :update, :destroy]

  add_breadcrumb "Tipos", :agreement_types

  def index
    @agreement_types = AgreementType.all
  end

  def show
    add_breadcrumb @agreement_type.name, agreement_type_path(@agreement_type)
  end

  def edit
    add_breadcrumb @agreement_type.name, agreement_type_path(@agreement_type)
    add_breadcrumb "Edición", edit_agreement_type_path(@agreement_type)
  end

  def new
    @agreement_type = AgreementType.new

    add_breadcrumb "Nuevo", '#'

  end

  def create
    @agreement_type = AgreementType.new(agreement_type_params)
    if @agreement_type.save
      redirect_to agreement_types_path, notice: 'Agreement Type was successfully created.'
    else
      render :new
    end
  end

  def update
    if @agreement_type.update(agreement_type_params)
      redirect_to agreement_type_path(@agreement_type), notice: 'Agreement Type was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @agreement_type.destroy
    redirect_to agreement_types_path, notice: 'Agreement Type was successfully deleted.'
  end

  private

  def set_agreement_type
    @agreement_type = AgreementType.find(params[:id])
  end

  def agreement_type_params
    params.require(:agreement_type).permit(:name, :description, :required_documents, :requires_technical_responsible, :has_financial_terms)
  end

end
