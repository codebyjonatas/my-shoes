# Controller da área administrativa de calçados (CRUD completo).
#
# Segue o padrão de controller fino: cada action apenas orquestra a
# resposta HTTP delegando as regras de negócio para +ShoeQuery+,
# +Shoes::CreateService+ e +Shoes::UpdateService+.
#
# @author codebyjonatas
module Admin
  class ShoesController < ApplicationController
    before_action :set_shoe, only: %i[show edit update destroy]

    # Lista todos os calçados (ativos e inativos).
    #
    # @return [void]
    def index
      @shoes = ShoeQuery.new(index_params).call
      @brands = Brand.order(:name)
    end

    # Exibe um calçado e suas variantes.
    #
    # @return [void]
    def show
      @variants = @shoe.shoe_variants.includes(:size).order("sizes.value_cm")
    end

    # Renderiza o formulário de criação.
    #
    # @return [void]
    def new
      @shoe = Shoe.new
      @shoe.shoe_variants.build
    end

    # Cria um calçado via +Shoes::CreateService+.
    #
    # @return [void]
    def create
      result = Shoes::CreateService.new(shoe_params).call

      if result.success?
        redirect_to admin_shoe_path(result.shoe), notice: "Calçado criado com sucesso."
      else
        @shoe = Shoe.new(shoe_params.slice(:name, :description, :gender, :brand_id, :category_id))
        @shoe.errors.merge!(result.errors)
        render :new, status: :unprocessable_entity
      end
    end

    # Renderiza o formulário de edição.
    #
    # @return [void]
    def edit
    end

    # Atualiza um calçado via +Shoes::UpdateService+.
    #
    # @return [void]
    def update
      result = Shoes::UpdateService.new(@shoe, shoe_params).call

      if result.success?
        redirect_to admin_shoe_path(result.shoe), notice: "Calçado atualizado com sucesso."
      else
        @shoe.errors.merge!(result.errors)
        render :edit, status: :unprocessable_entity
      end
    end

    # Remove um calçado e suas variantes.
    #
    # @return [void]
    def destroy
      @shoe.destroy
      redirect_to admin_shoes_path, notice: "Calçado removido."
    end

    private

    # Carrega o calçado para as actions que precisam dele.
    #
    # @return [void]
    def set_shoe
      @shoe = Shoe.find(params[:id])
    end

    # Parâmetros aceitos para a consulta da listagem administrativa.
    #
    # @return [ActionController::Parameters] parâmetros permitidos.
    def index_params
      params.permit(:gender, :in_stock, :search)
    end

    # Strong parameters do formulário de calçado com variantes aninhadas.
    #
    # @return [ActionController::Parameters] parâmetros permitidos.
    def shoe_params
      params.require(:shoe).permit(
        :name, :description, :gender, :brand_id, :category_id,
        shoe_variants_attributes: %i[size_id price stock_quantity]
      )
    end
  end
end
