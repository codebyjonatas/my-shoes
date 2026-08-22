# Representa uma marca de calçados no catálogo da loja.
#
# É um dado mestre (reference data): o nome é único no sistema e funciona
# como identificador de negócio para todos os sapatos associados. Por
# isso, quando há sapatos vinculados, a marca não pode ser removida.
#
# @author codebyjonatas
#
# @example Consultando uma marca com seus sapatos
#   query_brand = Brand.find_by(name: "Nike")
#   query_brand.shoes.map(&:name) # => ["Air Max", "Air Force 1"]
#
# @attr [String] name Nome da marca. Obrigatório e único no sistema.
# @attr [String] description Descrição opcional com detalhes da marca.
class Brand < ApplicationRecord
  has_many :shoes, dependent: :restrict_with_error, inverse_of: :brand

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
