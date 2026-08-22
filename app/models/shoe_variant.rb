# Representa variantes de calçados do catálogo da loja.
#
# Representa a instância concreta de um calçado em um tamanho, carregando preço e estoque.
#
# @author codebyjonatas
#
# @example Obtendo a variante em estoque de um calçado
#   shoe = Shoe.find_by(name: "Air Max")
#   variant = shoe.shoe_variants.joins(:size).where(stock_quantity: 5).first
#
# @attr [Shoe] shoe Calçado associado à variante. Obrigatório e deve existir no sistema.
# @attr [Size] size Tamanho associado à variante. Obrigatório e deve existir no sistema.
# @attr [Decimal] price Preço da variante. Obrigatório e deve ser maior que zero.
# @attr [Integer] stock_quantity Quantidade em estoque da variante. Obrigatório e deve ser maior ou igual a zero.
class ShoeVariant < ApplicationRecord
  belongs_to :shoe
  belongs_to :size

  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :size, uniqueness: { scope: :shoe_id }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
