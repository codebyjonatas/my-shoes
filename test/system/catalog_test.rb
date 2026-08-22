require "application_system_test_case"

class CatalogTest < ApplicationSystemTestCase
  test "exibe o catalogo apenas com calcados ativos" do
    visit root_url

    assert_selector "h1", text: "Catálogo de Calçados"
    assert_text "Air Max"
    assert_text "Superstar"
    assert_no_text "Old Skool"
  end

  test "filtra o catalogo por genero feminino" do
    visit root_url

    select "Feminino", from: "gender"
    click_on "Filtrar"

    assert_text "Superstar"
    assert_no_text "Air Max"
    assert_no_text "Maxima Pro"
  end
end
