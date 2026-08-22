# Encapsula o caso de uso "criar um calçado com suas variantes",
# orquestrando o +ShoeForm+ e devolvendo um resultado estruturado.
#
# O controller permanece fino: ele apenas orquestra a resposta HTTP com
# base no +Result+ retornado, sem conhecer regras de negócio.
#
# @author codebyjonatas
#
# @example
#   result = Shoes::CreateService.new(params[:shoe]).call
#   result.success? # => true
class Shoes::CreateService
  # Resultado estruturado da execução do serviço.
  #
  # @attr [Boolean] success se a operação foi bem-sucedida
  # @attr [Shoe, nil] shoe o calçado criado (ou nil em falha)
  # @attr [ActiveModel::Errors, nil] errors erros do formulário (em falha)
  Result = Struct.new(:success, :shoe, :errors, keyword_init: true) do
    # @return [Boolean] verdadeiro se a operação foi bem-sucedida
    def success?
      success
    end
  end

  # Inicializa o serviço com os parâmetros crus do formulário.
  #
  # @param params [ActionController::Parameters] parâmetros aceitos de +shoe+
  def initialize(params)
    @params = params
  end

  # Executa a criação do calçado.
  #
  # @return [Shoes::CreateService::Result] resultado com sucesso e registro
  def call
    form = ShoeForm.new(shoe_attributes)

    if form.save
      Result.new(success: true, shoe: form.shoe)
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
end
