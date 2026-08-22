# My Shoes — Documentação do Ambiente e Como Usar

Aplicação Rails 8.1.3 para catálogo de sapatos com área administrativa.
Stack: Ruby 4.0.5 + PostgreSQL + Tailwind + Turbo/Hotwire + Kamal.

---

## Pré-requisitos

| Item | Versão | Como instalar (CachyOS/Arch) |
|------|--------|------------------------------|
| Ruby | 4.0.5 | `rbenv install 4.0.5 && rbenv global 4.0.5` |
| PostgreSQL | >= 16 | `sudo pacman -S postgresql` |
| Node.js | >= 20 | `sudo pacman -S nodejs npm` |
| Bundler | latest | `gem install bundler` |
| Git | any | `sudo pacman -S git` |

> Dica: use `asdf` ou `rbenv` para gerenciar versões do Ruby.
> Após instalar Ruby 4.0.5, execute `rbenv rehash`.

---

## Setup Inicial

```bash
# 1. Clone e entre no projeto
git clone <repo-url> ~/Documentos/my-shoes
cd ~/Documentos/my-shoes

# 2. Instale dependências
bundle install

# 3. Garanta que o PostgreSQL está rodando
sudo systemctl start postgresql

# 4. Crie o banco de desenvolvimento
bin/rails db:create

# 5. Rode as migrations
bin/rails db:migrate

# 6. (Opcional) Popule com dados de exemplo
bin/rails db:seed

# 7. Inicie o servidor
bin/rails server
```

Acesse: **http://localhost:3000**

---

## Estrutura do Projeto

```
app/
  controllers/
    admin/
      shoes_controller.rb    # CRUD administrativo de sapatos
    catalog_controller.rb     # Página pública do catálogo
  models/
    shoe.rb                   # Modelo principal
    shoe_variant.rb           # Variantes (tamanho/estoque/preço)
    brand.rb                  # Marcas
    category.rb               # Categorias
    size.rb                   # Tamanhos
  services/                   # Lógica de negócio
  forms/                      # Form objects
  queries/                    # Objetos de consulta
config/
  routes.rb                   # Rotas públicas + admin
  database.yml                # PostgreSQL (dev/test/prod)
db/
  migrate/                    # Migrations
  schema.rb                   # Schema atual
  seeds.rb                    # Dados de exemplo
```

---

## Rotas

| Rota | Método | Função |
|------|--------|--------|
| `/` | GET | Catálogo público (somente leitura) |
| `/admin/shoes` | GET | Listagem de sapatos (admin) |
| `/admin/shoes/new` | GET | Novo sapato (admin) |
| `/admin/shoes/:id` | GET | Detalhes (admin) |
| `/admin/shoes/:id/edit` | GET | Edição (admin) |
| `/admin/shoes` | POST | Criação (admin) |
| `/admin/shoes/:id` | PATCH/PUT | Atualização (admin) |
| `/admin/shoes/:id` | DELETE | Remoção (admin) |
| `/up` | GET | Health check (Rails) |

---

## Banco de Dados

### Schema Principal

- **brands**: `name` (único), `description`
- **categories**: `name` (único), `position`
- **sizes**: `label` (único), `value_cm`
- **shoes**: `name`, `gender`, `active`, `brand_id`, `category_id`, `description`
- **shoe_variants**: `shoe_id`, `size_id`, `price`, `stock_quantity`

### Comandos Úteis

```bash
# Criar migration
bin/rails generate migration NomeDaMigration

# Aplicar migrations
bin/rails db:migrate

# Reverter última migration
bin/rails db:rollback

# Popular banco
bin/rails db:seed

# Abrir console Rails
bin/rails console

# Abrir console do banco
bin/rails dbconsole
```

---

## Executando a Aplicação

### Servidor de Desenvolvimento

```bash
bin/rails server
# ou
bin/rails s
```

Acesse: **http://localhost:3000**

### Console Rails

```bash
bin/rails console
# ou
bin/rails c
```

Exemplos úteis no console:
```ruby
# Listar todos os sapatos
Shoe.all

# Criar uma marca
Brand.create!(name: "Nike", description: "Esportiva")

# Criar um sapato
Shoe.create!(name: "Air Max", gender: "masculino", brand: nike, category: categoria)

# Ver variantes de um sapato
shoe.shoe_variants.includes(:size)
```

### Testes

```bash
# Rodar todos os testes
bin/rails test

# Rodar testes específicos
bin/rails test test/models/shoe_test.rb

# Rodar system tests
bin/rails test:system
```

### Lint/Code Style

```bash
# RuboCop (omakase Rails)
bin/rubocop

# Autocorrigir problemas simples
bin/rubocop -a
```

---

## Administração

Acesse a área admin em: **http://localhost:3000/admin/shoes**

Funcionalidades:
- **Listar** sapatos cadastrados
- **Criar** novo sapato com nome, gênero, marca, categoria e descrição
- **Editar** sapatos existentes
- **Ativar/Desativar** sapatos (campo `active`)
- **Gerenciar variantes** (tamanho, preço, estoque)

### Workflow de Cadastro

1. Acesse `/admin/shoes`
2. Clique em **Novo Sapato**
3. Preencha:
   - Nome
   - Gênero (`masculino`, `feminino`, `unissex`)
   - Marca (selecione ou crie)
   - Categoria (selecione ou crie)
   - Descrição (opcional)
4. Salve
5. Adicione variantes (tamanho + preço + estoque)

---

## Catálogo Público

Acesse a raiz (`/`) para ver o catálogo público.

Funcionalidades:
- Listagem de sapatos ativos
- Filtragem por categoria/marca
- Visualização de variantes (tamanhos disponíveis)

---

## Hotwire/Turbo

A aplicação usa Turbo para atualizações dinâmicas sem recarregar a página.

- **Turbo Drive**: navegação SPA-like
- **Turbo Frames**: atualizações parciais
- **Turbo Streams**: ações assíncronas

### JavaScript

- **Importmap**: gerenciamento de dependências JS sem build
- **Stimulus**: controllers para interatividade
- **Tailwind CSS**: estilização utility-first

---

## Variáveis de Ambiente

Edite via Rails credentials ou variáveis de ambiente:

```bash
# Editar credentials
EDITOR="nvim" bin/rails credentials:edit

# Ou use variáveis diretas
DATABASE_URL=postgres://user:pass@localhost/my_shoes_development bin/rails server
```

---

## Deploy (Kamal)

A aplicação usa Kamal para deploy em servidores.

```bash
# Verificar configuração
cat config/deploy.yml

# Deploy
kamal deploy

# Rollback
kamal rollback

# Acessar servidor
kamal app exec -- bash
```

> Requer Docker instalado no servidor de produção.

---

## Troubleshooting

### Erro de conexão com PostgreSQL

```bash
# Verifique se o PostgreSQL está rodando
sudo systemctl status postgresql

# Crie o banco se não existir
bin/rails db:create
```

### Porta 3000 em uso

```bash
# Use outra porta
bin/rails server -p 3001
```

### Erro de gems

```bash
# Reinstale gems
rm -rf .bundle vendor/bundle
bundle install
```

### Assets não carregam

```bash
# Limpe assets
bin/rails assets:clobber
bin/rails assets:precompile
```

---

## Comandos Rápidos

| Comando | Função |
|---------|--------|
| `bin/rails s` | Inicia servidor |
| `bin/rails c` | Abre console |
| `bin/rails db:migrate` | Aplica migrations |
| `bin/rails db:seed` | Popula banco |
| `bin/rails test` | Roda testes |
| `bin/rubocop` | Lint |
| `bin/rails routes` | Lista rotas |

---

## Integração com Seu Setup

### Neovim

Use os comandos Rails no Neovim via `vim-rails` ou `vim-dispatch`:

```vim
" Executar migrations
:!bin/rails db:migrate

" Rodar testes
:!bin/rails test

" Abrir console
:!bin/rails console
```

### tmux

Sessão recomendada:

```bash
# Sessão principal
tmux new -s my-shoes

# Janela 1: servidor
bin/rails server

# Janela 2: console
bin/rails console

# Janela 3: tail logs
tail -f log/development.log
```

### IDE/Editor

Se usar Neovim com `vim-rails`:
- `:E` para explorar estrutura
- `:Emodel shoe` para editar model
- `:Eview catalog/index` para editar view

---

## Próximos Passos

1. Explore o catálogo em `/`
2. Cadastre marcas e categorias no admin
3. Crie sapatos com variantes
4. Customize o layout em `app/views/`
5. Adicione mais funcionalidades (carrinho, checkout, etc.)
