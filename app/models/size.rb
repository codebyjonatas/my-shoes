# Representa variações de tamanho de calçados no catálogo da loja.
#
# É um dado mestre (reference data):
# o número do tamanho é único no sistema e serve de rótulo de agrupamento
# dos calçados que pertencem a ele.
#
# @author codebyjonatas
#
# @example Consultando tamanho de calçado
# query_size = Size.find_by(label: "42").shoe_variants.map { |v| v.shoe.name }
#
# @attr [String] label Rótulo do tamanho. Obrigatório e único no sistema.
# @attr [Decimal] value_cm Valor do tamanho em centímetros. Obrigatório e único no sistema.
class Size < ApplicationRecord
  has_many :shoe_variants, dependent: :restrict_with_error, inverse_of: :size

  validates :label, presence: true, uniqueness: { case_sensitive: false }
  validates :value_cm, presence: true, numericality: { greater_than: 0 }
end
