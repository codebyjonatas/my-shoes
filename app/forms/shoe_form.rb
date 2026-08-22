# Encapsula a validação e persistência do formulário de um calçado,
# agregando o +Shoe+ e suas variantes (+ShoeVariant+) em uma única
# operação transacional.
#
# Este objeto isola o controller das regras transversais de negócio:
# "um sapato precisa de pelo menos uma variante válida". O +Shoe+ e o
# +ShoeVariant+ permanecem como entidades puras, sem conhecer o formato
# de entrada HTTP (nested attributes).
#
# @author codebyjonatas
#
# @example Criando um sapato com variantes
#   form = ShoeForm.new(
#     name: "Air Max", gender: "male",
#     brand_id: 1, category_id: 2,
#     shoe_variants_attributes: {
#       "0" => { size_id: 41, price: "299.99", stock_quantity: "5" }
#     }
#   )
#   form.save # => true
class ShoeForm
  include ActiveModel::Model

  attr_accessor :name, :description, :gender, :brand_id, :category_id
  attr_accessor :shoe_variants_attributes

  # O calçado persistido pela última execução de +save+ (nil antes disso).
  #
  # @return [Shoe, nil] calçado criado com sucesso.
  attr_reader :shoe

  validates :name, presence: true
  validates :gender, presence: true, inclusion: { in: %w[male female unisex] }
  validate :at_least_one_variant
  validate :validate_variants

  # Persiste o calçado e suas variantes em uma transação única.
  #
  # Se qualquer variante for inválida ou a transação falhar, nenhum
  # registro é gravado e os erros ficam disponíveis em +errors+.
  #
  # @return [Shoe, false] o calçado criado em caso de sucesso, ou +false+
  #   se a validação/persistência falhar (o registro é exposto em +shoe+).
  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      @shoe = Shoe.create!(shoe_attributes)
      create_variants(@shoe)
      @shoe
    end
  rescue ActiveRecord::RecordInvalid => e
    copy_errors(e.record)
    false
  end

  private

  # Garante que o formulário possua ao menos uma variante declarada.
  #
  # @return [void]
  def at_least_one_variant
    return if variants_hashes.any?

    errors.add(:shoe_variants, "é obrigatório informar pelo menos uma variante")
  end

  # Valida cada variante individualmente, propagando os erros para o form.
  #
  # Registrado via +validate :validate_variants+, roda automaticamente na
  # cadeia de validação do ActiveModel. As variantes são validadas já
  # associadas a um +Shoe+ em memória, para satisfazer a presença de
  # +shoe+ exigida pelo model sem persistir.
  #
  # @return [void]
  def validate_variants
    shoe = Shoe.new(shoe_attributes)
    variants_hashes.each_with_index do |attrs, index|
      variant = build_variant(attrs)
      variant.shoe = shoe
      next if variant.valid?

      variant.errors.full_messages.each do |message|
        errors.add(:shoe_variants, "variante #{index + 1}: #{message}")
      end
    end
  end

  # Normaliza os atributos crus de uma variante para as chaves aceitas.
  #
  # @param attrs [Hash, ActionController::Parameters] atributos crus da
  #   variante (aceita chaves em formato string ou símbolo).
  # @return [Hash] hash com +:size_id+, +:price+ e +:stock_quantity+.
  def variant_attributes(attrs)
    attrs.to_h.symbolize_keys.slice(:size_id, :price, :stock_quantity)
  end

  # Constrói um +ShoeVariant+ (sem persistir) a partir dos atributos.
  #
  # @param attrs [Hash, ActionController::Parameters] atributos crus de uma
  #   variante (aceita chaves em formato string ou símbolo).
  # @return [ShoeVariant] variante não persistida.
  def build_variant(attrs)
    ShoeVariant.new(variant_attributes(attrs))
  end

  # Cria as variantes persistidas para o calçado recém-criado.
  #
  # @param shoe [Shoe] calçado pai das variantes.
  # @return [Array<ShoeVariant>] variantes criadas.
  def create_variants(shoe)
    variants_hashes.map do |attrs|
      shoe.shoe_variants.create!(variant_attributes(attrs))
    end
  end


  # Atributos para criação do +Shoe+.
  #
  # @return [Hash] hash com as chaves aceitas pelo model.
  def shoe_attributes
    {
      name: name,
      description: description,
      gender: gender,
      brand_id: brand_id,
      category_id: category_id
    }
  end

  # Normaliza os atributos de variantes vindos do form em um array.
  #
  # @return [Array<ActionController::Parameters>] hashes das variantes.
  def variants_hashes
    @variants_hashes ||= shoe_variants_attributes.to_h.values
  end

  # Copia os erros de um registro inválido para o formulário.
  #
  # @param record [ActiveRecord::Base] registro que falhou na transação.
  # @return [void]
  def copy_errors(record)
    record.errors.each do |error|
      errors.add(error.attribute, error.message)
    end
  end
end
