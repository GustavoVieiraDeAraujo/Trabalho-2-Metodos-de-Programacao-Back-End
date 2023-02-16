module Api
  module V1
    # Controlador para gerenciar provas.
    class QuizController < ApplicationController
      # Autentica o token de autenticação do usuario para as ações de create, delete e update.
      acts_as_token_authentication_handler_for User, only: %i[create delete update add_question]

      # ==== Ação para listar todos as provas cadastrados no sistema.
      #
      # Busca por todos as provas no banco de dados.
      #
      # ==== Exemplo de uso:
      #
      #   GET /quiz
      #
      # Retorna um objeto JSON com os dados de todos as provas e um status HTTP 200 (OK).
      # Se a prova não existir, retorna um status HTTP 400(bad_request)
      #
      # ==== Raises:
      # - StandardError: se ocorrer um erro durante a listagem .
      #

      def index
        quiz = Quiz.all
        render json: quiz, status: :ok
      rescue StandardError => e
        render json: e, status: :bad_request
      end

      # ==== Ação para exibir as informações de uma prova pelo ID.
      #
      # Busca pelo ID especifico da prova.
      #
      # ==== Exemplo de uso:
      #
      #   GET /quiz/:id
      #
      # Retorna um objeto JSON com as informações da prova e um status HTTP 200 (OK).
      # Se o prova não existir, retorna um status HTTP 404 (Not Found).
      #
      # ==== Raises:
      # - StandardError: se ocorrer um erro durante a busca.
      #

      def show
        quiz = Quiz.find(params[:id])
        render json: quiz, status: :ok
      rescue StandardError
        head(:not_found)
      end

      # ==== Ação para criar uma prova.
      #
      # Utiliza os parametros necessários para cria um prova.
      #
      # ==== Exemplo de uso:
      #
      #   POST /quiz
      #   params: { title: "Titulo da prov", subject: "materia da sua prova", user_id: user.id, team_id: team.id }
      #
      # Cria uma nova prova com os parâmetros passados e retorna um objeto JSON com as informações da prova criado e um status HTTP 201 (Created).
      # Caso os devidos paremetros não exisita retorna o status de 400 (bad_request)
      #
      # Raises:
      # - StandardError: se ocorrer um erro durante a criação do prova.
      #

      def create
        quiz = Quiz.create!(quiz_params)
        quiz.save!
        render json: quiz, status: :created
      rescue StandardError => e
        render json: e, status: :bad_request
      end

      # ==== Ação para atualizar as informações de uma prova.
      #
      # Busca pela ID específica da prova para atualiza-la
      #
      # ==== Exemplo de uso:
      #
      #   PUT /quiz/:id
      #   params: { title: "Titulo da prova", subject: "materia da sua prova", user_id: user.id, team_id: team.id }
      #
      #
      # Atualiza as informações da prova com os parâmetros passados e retorna um objeto JSON com as informações do prova atualizado e um status HTTP 200 (OK).
      # Se a prova não existir, retorna um status HTTP 422 (unprocessable_entity).
      #
      # ==== Raises:
      # - StandardError: se ocorrer um erro durante a atualização do prova.
      #

      def update
        quiz = Quiz.find(params[:id])
        quiz.update!(quiz_params)
        render json: quiz, status: :ok
      rescue StandardError => e
        render json: e, status: :unprocessable_entity
      end

      # Método para excluir uma prova do banco de dados
      #
      # Exemplo de uso:
      #
      #   DELETE /quiz/:id
      #
      # Em caso de sucesso retorna o status HTTP 200 (ok) com a seguinte mensagem:
      #   # Response
      #     "message": "prova {nome da prova} deletada com sucesso"
      #
      # Em caso de erro, é renderizada uma mensagem de erro com o status HTTP 400.

      def delete
        quiz = Quiz.find(params[:id])
        quiz.destroy!
        render json: { message: 'Prova deletada com sucesso' }, status: :ok
      rescue StandardError => e
        render json: e, status: :bad_request
      end

      # Adiciona uma questao a uma prova
      def add_question
        quiz = Quiz.find(params[:quiz_id])
        question = Question.find(params[:question_id])
        QuizQuestion.create!(quiz: quiz, question: question)
        render json: { message: "Questao adicionada a prova #{quiz.title}" }, status: :ok
      rescue StandardError => e
        render json: { error: e.message }, status: :bad_request
      end

      private

      # Retorna um hash sanitizado de parâmetros de quiz para criar, atualizar ou deletar uma prova.
      #
      # O hash inclui as seguintes chaves:
      # - title: o tirulo da prova (string)
      # - subject: a materia da prova (string)
      # - user_id: a que usuario aquela prova esta atrelada (int)
      # - team_id: a turma que a porva estara atrelada (int)
      #
      # Exemplo de uso:
      #   def create
      #     quiz = Quiz.new(team_params)
      #     # ...
      #   end
      #
      # Retorna: um hash de parâmetros da prova sanitizados

      def quiz_params
        params.require(:quiz).permit(:title, :subject, :user_id, :team_id)
      end
    end
  end
end
