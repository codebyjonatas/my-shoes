Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Página pública da loja (catálogo somente leitura).
  root "catalog#index"

  # Área administrativa: CRUD completo de sapatos.
  namespace :admin do
    resources :shoes
  end
end
