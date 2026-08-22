# Controller da página pública da loja (catálogo somente leitura).
#
# Usa o +ShoeQuery+ para compor os filtros da vitrine e aplica os scopes
# de exibição (+active+, +in_stock+) apenas aqui, mantendo a regra de
# catálogo isolada da área administrativa.
#
# @author codebyjonatas
class CatalogController < ApplicationController
  # Lista o catálogo de calçados disponíveis para venda.
  #
  # @return [void]
  def index
    @shoes = ShoeQuery.new(index_params).call.active.in_stock
    @brands = Brand.order(:name)
    @categories = Category.order(:position)
  end

  private

  # Parâmetros aceitos para a consulta do catálogo.
  #
  # @return [ActionController::Parameters] parâmetros permitidos.
  def index_params
    params.permit(:gender, :in_stock, :search)
  end
end
