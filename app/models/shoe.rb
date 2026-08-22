# Representa um calçado no catálogo da loja.
#
# É um dado mestre (reference data): o nome é único no sistema e funciona
# como identificador de negócio para todos os tamanhos de sapato associados.
# Os calçados são categorizados por gênero, marca e categoria, que são obrigatórios e devem existir no sistema.
#
# @author codebyjonatas
#
# @example Consultando um calçado por nome
# query_shoe = Shoe.find_by(name: "Air Max")
# query_shoe.shoe_variants.where("stock_quantity > 0").count
#
# @attr [String] name Nome do calçado. Obrigatório e único no sistema.
# @attr [String] description Descrição opcional com detalhes do calçado.
# @attr [String] gender Gênero do calçado. Obrigatório e deve ser um dos valores permitidos.
# @attr [Brand] brand Marca do calçado. Obrigatória e deve existir no sistema.
# @attr [Category] category Categoria do calçado. Obrigatória e deve existir no sistema.
class Shoe < ApplicationRecord
  belongs_to :brand
  belongs_to :category

  has_many :shoe_variants, dependent: :destroy, inverse_of: :shoe

  validates :name, presence: true, uniqueness: { scope: :brand_id, case_sensitive: false }
  validates :gender, presence: true, inclusion: { in: %w[male female unisex] }

  # @!method self.active
  #   Retorna apenas calçados ativos (não descontinuados).
  #   @return [ActiveRecord::Relation<Shoe>]
  scope :active, -> { where(active: true) }

  # @!method self.by_gender(gender)
  #   Retorna calçados filtrados por gênero.
  #   @return [ActiveRecord::Relation<Shoe>]
  scope :by_gender, ->(gender) { where(gender: gender) }

  # @!method self.in_stock
  #   Retorna calçados que possuem pelo menos uma variante em estoque.
  #   @return [ActiveRecord::Relation<Shoe>]
  scope :in_stock, -> { joins(:shoe_variants).where("shoe_variants.stock_quantity > 0").distinct }

  # @!method self.search(term)
  #   Retorna calçados cujo nome ou descrição contenha o termo (case insensitive).
  #   @param [String] term termo de busca
  #   @return [ActiveRecord::Relation<Shoe>]
  scope :search, ->(term) { where("name ILIKE ? OR description ILIKE ?", "%#{term}%", "%#{term}%") }
end
