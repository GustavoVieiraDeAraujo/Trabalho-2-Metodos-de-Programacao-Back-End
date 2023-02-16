# Plataforma de Questoes — Back-End

Projeto da disciplina **Metodos de Programacao (MP)** do Departamento de Ciencia da Computacao da Universidade de Brasilia. API RESTful em Ruby on Rails para uma plataforma de questoes academicas, onde professores criam perguntas e alunos as respondem, com rastreamento de estatisticas e organizacao por turmas.

> **Front-End:** [MP-Front-End](https://github.com/GustavoVieiraDeAraujo/MP-Front-End)

---

## Sumario

- [Participantes](#participantes)
- [Tecnologias](#tecnologias)
- [Escopo do Projeto](#escopo-do-projeto)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Requisitos](#requisitos)
- [Como Executar](#como-executar)
- [Endpoints da API](#endpoints-da-api)
- [Modelo de Dados](#modelo-de-dados)
- [Testes](#testes)

---

## Participantes

| Nome                              | Matricula |
|-----------------------------------|-----------|
| Gustavo Vieira de Araujo          | 211068440 |
| Caetano Korilo                    | 212006737 |
| Arthur Antero de Sa               | 212006577 |
| Luiz Henrique Figueiredo Soares   | 211068403 |

---

## Tecnologias

| Tecnologia                    | Uso                                              |
|-------------------------------|--------------------------------------------------|
| Ruby 2.7.4                    | Linguagem                                        |
| Rails 6.1.7.2 (API-only)     | Framework web                                    |
| PostgreSQL                    | Banco de dados                                   |
| Devise                        | Autenticacao de usuarios                         |
| simple_token_authentication   | Autenticacao por token na API                    |
| active_model_serializers      | Serializacao JSON das respostas                  |
| RSpec + FactoryBot            | Testes automatizados                             |
| RuboCop                       | Linting                                          |
| RDoc                          | Documentacao do codigo                           |

---

## Escopo do Projeto

| Requisito                          | Implementacao                                                |
|------------------------------------|--------------------------------------------------------------|
| CRUD de Usuario                    | Cadastro, login (token), consulta, edicao, exclusao          |
| CRUD de Questao                    | Criar, listar, consultar, editar e excluir questoes           |
| CRUD de Quiz                       | Criar, listar, consultar, editar e excluir provas             |
| CRUD de Turma                      | Criar, listar, consultar, editar e excluir turmas             |
| Estatisticas                       | Rastreamento de questoes respondidas, acertos e erros         |
| Autenticacao por token             | Devise + simple_token_authentication                          |
| Papeis de usuario                  | Admin, Professor e Aluno                                      |
| Testes automatizados               | RSpec com specs de modelo e requisicao                        |
| Documentacao                       | RDoc geravel via `rdoc`                                      |

---

## Estrutura do Projeto

| Diretorio / Arquivo                           | Descricao                                              |
|-----------------------------------------------|--------------------------------------------------------|
| `app/controllers/api/v1/`                     | Controllers da API (user, question, quiz, team, statistic) |
| `app/models/`                                 | Modelos (User, Question, Quiz, Team, Statistic + joins) |
| `app/serializers/`                            | Serializadores JSON para cada entidade                  |
| `config/routes.rb`                            | Rotas da API sob `/api/v1/`                             |
| `db/migrate/`                                 | Migracoes do banco                                      |
| `db/schema.rb`                                | Schema atual do banco                                   |
| `db/seeds.rb`                                 | Dados iniciais para desenvolvimento                     |
| `spec/models/`                                | Testes de modelo (RSpec)                                |
| `spec/requests/api/v1/`                       | Testes de requisicao (RSpec)                            |
| `spec/factories/`                             | Factories para testes (FactoryBot)                      |

---

## Requisitos

- Ruby 2.7.4
- Rails 6.1.7.2
- PostgreSQL

```bash
# Ubuntu/Debian
sudo apt install postgresql libpq-dev
```

---

## Como Executar

```bash
# Instalar dependencias
bundle install

# Criar e popular o banco
rails db:create
rails db:migrate
rails db:seed

# Iniciar o servidor (porta 3000)
rails s
```

Para gerar documentacao:

```bash
rdoc
# Abre doc/index.html no navegador
```

---

## Endpoints da API

Base URL: `http://localhost:3000/api/v1`

### Usuario

| Metodo | Rota               | Acao                  |
|--------|--------------------|-----------------------|
| POST   | `/user/login`      | Autenticar            |
| DELETE | `/user/logout`     | Encerrar sessao       |
| GET    | `/user/index`      | Listar usuarios       |
| GET    | `/user/show/:id`   | Consultar usuario     |
| POST   | `/user/create`     | Cadastrar usuario     |
| PATCH  | `/user/update/:id` | Editar usuario        |
| DELETE | `/user/delete/:id` | Excluir usuario       |

### Questao

| Metodo | Rota                   | Acao                  |
|--------|------------------------|-----------------------|
| GET    | `/question/index`      | Listar questoes       |
| GET    | `/question/show/:id`   | Consultar questao     |
| POST   | `/question/create`     | Criar questao         |
| PATCH  | `/question/update/:id` | Editar questao        |
| DELETE | `/question/delete/:id` | Excluir questao       |

### Quiz, Turma e Estatistica

Seguem o mesmo padrao: `GET index`, `GET show/:id`, `POST create`, `PATCH update/:id`, `DELETE delete/:id`.

---

## Modelo de Dados

| Entidade     | Campos                                                              | Relacoes                        |
|--------------|---------------------------------------------------------------------|---------------------------------|
| User         | name, email, enrollment, password, is_admin, is_student, is_teacher | has_many questions, quizzes, teams |
| Question     | title, description, subject, answer, user_id                       | belongs_to user                 |
| Quiz         | title, subject, user_id, team_id                                   | belongs_to user, team; has_many questions |
| Team         | name, user_id                                                      | belongs_to user; has_many students, quizzes |
| Statistic    | questions_answered, right_answers, wrong_answers, user_id           | belongs_to user                 |

---

## Testes

```bash
# Executar todos os testes
rspec

# Executar linting
rubocop
```

Cobertura: specs de modelo (8) + specs de requisicao (5) para todos os endpoints principais.
