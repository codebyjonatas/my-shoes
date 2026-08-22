# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

(34..44).each do |number|
  cm = 22.0 + (number - 34) * (2.0 / 3.0)
  Size.find_or_create_by!(value_cm: cm.round(2)) do |size|
    size.label = number.to_s
  end
end

[ "Nike", "Adidas", "Puma", "Vans" ].each do |brand_name|
  Brand.find_or_create_by!(name: brand_name) do |brand|
    brand.description = "#{brand_name} - Qualidade em calçados."
  end
end

[ [ "Tênis", 1 ], [ "Casual", 2 ], [ "Esportivo", 3 ], [ "Social", 4 ] ].each do |name, position|
  Category.find_or_create_by!(name: name) do |category|
    category.position = position
  end
end

shoes = [
  {
    name: "Air Max", gender: "male", brand: "Nike", category: "Tênis",
    description: "O Nike Air Max é uma linha famosa de calçados da Nike que se destaca pela tecnologia de amortecimento visível com cápsulas de ar pressurizado no calcanhar. Combinando estilo urbano e conforto para o dia a dia, a família conta com diversos modelos icônicos como o Air Max 90, SC e Excee.",
    variants: [ [ 41, 299.99, 5 ], [ 42, 299.99, 3 ] ]
  },

  {
    name: "Superstar", gender: "female", brand: "Adidas", category: "Casual",
    description: "O Adidas Superstar é um tênis icônico da marca, conhecido por seu design clássico e atemporal. Com cabedal em couro, biqueira de borracha e o famoso logo de três listras, o Superstar combina estilo urbano e conforto para o dia a dia.",
    variants: [ [ 36, 249.99, 10 ], [ 37, 249.99, 8 ] ]
  },

  {
    name: "Maxima Pro", gender: "unisex", brand: "Puma", category: "Esportivo",
    description: "O Puma Maxima Pro é um tênis esportivo de alto desempenho, projetado para atletas e entusiastas do esporte. Com tecnologia de amortecimento avançada, cabedal respirável e solado de alta tração, o Maxima Pro oferece conforto, estabilidade e suporte durante atividades físicas intensas.",
    variants: [ [ 38, 199.99, 15 ], [ 39, 199.99, 12 ] ]

  },

  {
    name: "Air Force 1 Low Black Patent", gender: "male", brand: "Nike", category: "Social",
    description: "O Air Force 1 - Low Black Patent, aposta no acabamento em couro envernizado para garantir o brilho intenso e a estética refinada.",
    variants: [ [ 41, 299.99, 5 ], [ 44, 299.99, 5 ] ]
  },

  {
    name: "Vans Old Skool", gender: "unisex", brand: "Vans", category: "Tênis",
    description: "O Vans Old Skool é um tênis clássico da marca, conhecido por seu design icônico e estilo atemporal. Com cabedal em lona e camurça, solado de borracha vulcanizada e a famosa faixa lateral, o Old Skool combina conforto, durabilidade e autenticidade para o dia a dia.",
    variants: [ [ 38, 199.99, 10 ], [ 39, 199.99, 8 ] ]
  },

  {
    name: "Puma Suede Classic", gender: "female", brand: "Puma", category: "Casual",
    description: "O Puma Suede Classic é um tênis icônico da marca, conhecido por seu design clássico e estilo atemporal. Com cabedal em camurça, solado de borracha e o famoso logo da Puma, o Suede Classic combina conforto, durabilidade e autenticidade para o dia a dia.",
    variants: [ [ 36, 249.99, 10 ], [ 37, 249.99, 8 ] ]
  }
]

shoes.each do |attrs|
  shoe = Shoe.find_or_create_by!(name: attrs[:name], brand_id: Brand.find_by!(name: attrs[:brand]).id) do |s|
    s.gender = attrs[:gender]
    s.category = Category.find_by!(name: attrs[:category])
    s.description = attrs[:description]
  end

  attrs[:variants].each do |size_num, price, stock|
    size = Size.find_by!(label: size_num.to_s)
    shoe.shoe_variants.find_or_create_by!(size: size) do |v|
      v.price = price
      v.stock_quantity = stock
    end
  end
end
