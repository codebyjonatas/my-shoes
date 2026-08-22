# Representa uma categoria de calçado no catálogo da loja.
#
# É um dado mestre (reference data): o nome é único no sistema e serve de
# rótulo de agrupamento dos calçados que pertencem a ela.
# Por isso, quando há sapatos vinculados, a categoria não pode ser removida.
#
# @author codebyjonatas
#
# @example Consultando uma categoria com seus sapatos
# query_category = Category.find_by(name: "Tênis")
# query_category.shoes.map(&:name) # => ["Air Max", "Air Force 1"]
#
# @attr [String] name Nome da categoria. Obrigatório e único no sistema.
# @attr [Integer] position Posição da categoria na listagem. Obrigatório.
class Category < ApplicationRecord
  has_many :shoes, dependent: :restrict_with_error, inverse_of: :category

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
