# Encapsula o caso de uso "atualizar um calçado e suas variantes".
#
# Diferente da criação, aqui o calçado já existe; o serviço atualiza os
# atributos base e reconstrói as variantes a partir do formulário,
# devolvendo um resultado estruturado para o controller.
#
# @author codebyjonatas
#
# @example
#   result = Shoes::UpdateService.new(shoe, params[:shoe]).call
#   result.success? # => true
class Shoes::UpdateService
  # Resultado estruturado da execução do serviço.
  #
  # @attr [Boolean] success se a operação foi bem-sucedida
  # @attr [Shoe, nil] shoe o calçado atualizado (ou nil em falha)
  # @attr [ActiveModel::Errors, nil] errors erros do formulário (em falha)
  Result = Struct.new(:success, :shoe, :errors, keyword_init: true) do
    # @return [Boolean] verdadeiro se a operação foi bem-sucedida
    def success?
      success
    end
  end

  # Inicializa o serviço com o calçado e os parâmetros do formulário.
  #
  # @param shoe [Shoe] calçado a ser atualizado
  # @param params [ActionController::Parameters] parâmetros aceitos de +shoe+
  def initialize(shoe, params)
    @shoe = shoe
    @params = params
  end

  # Executa a atualização do calçado e suas variantes.
  #
  # @return [Shoes::UpdateService::Result] resultado com sucesso e registro
  def call
    form = ShoeForm.new(shoe_attributes)

    if form.valid?
      update_shoe!
      Result.new(success: true, shoe: @shoe)
    else
      Result.new(success: false, errors: form.errors)
    end
  end

  private

  # Atributos normalizados para o +ShoeForm+.
  #
  # @return [Hash] hash aceito pelo formulário.
  def shoe_attributes
    @params.to_h.symbolize_keys
  end

  # Atualiza os campos base do calçado e reconstrói as variantes em
  # uma transação única.
  #
  # @return [void]
  def update_shoe!
    ActiveRecord::Base.transaction do
      @shoe.update!(base_attributes)
      replace_variants!
    end
  end

  # Atributos base do calçado (sem as variantes).
  #
  # @return [Hash] hash com as chaves de +Shoe+.
  def base_attributes
    shoe_attributes.slice(:name, :description, :gender, :brand_id, :category_id)
  end

  # Remove as variantes existentes e cria as novas informadas no form.
  #
  # @return [Array<ShoeVariant>] variantes criadas.
  def replace_variants!
    @shoe.shoe_variants.destroy_all
    shoe_attributes[:shoe_variants_attributes].to_h.values.map do |attrs|
      @shoe.shoe_variants.create!(attrs.symbolize_keys.slice(:size_id, :price, :stock_quantity))
    end
  end
end
