module Api
  module V1
    # Controlador para gerenciar questões.
    class QuestionController < ApplicationController
      # Autentica o token de autenticação do usuario para as ações de delete e update.
      acts_as_token_authentication_handler_for User, only: %i[create delete update]

      # ==== Ação para listar todos as questões cadastrados no sistema.
      #
      # Busca por todos as questões no banco de dados.
      #
      # ==== Exemplo de uso:
      #
      #   GET /question
      #
      # Retorna um objeto JSON com os dados de todos as questões e um status HTTP 200 (OK).
      # Se a questão não existir, retorna um status HTTP 400(bad_request)
      #
      # ==== Raises:
      # - StandardError: se ocorrer um erro durante a listagem .
      #

      def index
        question = Question.all
        render json: question, status: :ok
      rescue StandardError => e
        render json: e, status: :bad_request
      end

      # ==== Ação para exibir as informações de uma questão pelo ID.
      #
      # Busca pelo ID especifico da questão.
      #
      # ==== Exemplo de uso:
      #
      #   GET /question/:id
      #
      # Retorna um objeto JSON com as informações da questão e um status HTTP 200 (OK).
      # Se o questão não existir, retorna um status HTTP 404 (Not Found).
      #
      # ==== Raises:
      # - StandardError: se ocorrer um erro durante a busca.
      #

      def show
        question = Question.find(params[:id])
        render json: question, status: :ok
      rescue StandardError
        head(:not_found)
      end

      # ==== Ação para criar uma questão.
      #
      # Utiliza os parametros necessários para cria um questão.
      #
      # ==== Exemplo de uso:
      #
      #   POST /question
      #   params: { title: "titulo da questão", description: "descrição da questão", subject,"materia" answer:"resposta da questão", user_id: user.id }
      #
      # Cria uma nova questão com os parâmetros passados e retorna um objeto JSON com as informações da questão criado e um status HTTP 201 (Created).
      # Caso os devidos paremetros não exisita retorna o status de 400 (bad_request)
      #
      # Raises:
      # - StandardError: se ocorrer um erro durante a criação do questão.
      #

      def create
        question = Question.create!(question_params)
        question.save!
        render json: question, status: :created
      rescue StandardError => e
        render json: e, status: :bad_request
      end

      # ==== Ação para atualizar as informações de uma questão.
      #
      # Busca pela ID específica da questão para atualiza-la
      #
      # ==== Exemplo de uso:
      #
      #   PUT /question/:id
      #   params: { title: "titulo da questão", description: "descrição da questão", subject,"materia" answer:"resposta da questão", user_id: user.id }
      #
      #
      # Atualiza as informações da questão com os parâmetros passados e retorna um objeto JSON com as informações do questão atualizado e um status HTTP 200 (OK).
      # Se a questão não existir, retorna um status HTTP 422 (unprocessable_entity).
      #
      # ==== Raises:
      # - StandardError: se ocorrer um erro durante a atualização do questão.
      #

      def update
        question = Question.find(params[:id])
        question.update!(question_params)
        render json: question, status: :ok
      rescue StandardError => e
        render json: e, status: :unprocessable_entity
      end

      # Método para excluir uma questão do banco de dados
      #
      # Exemplo de uso:
      #
      #   DELETE /question/:id
      #
      # Em caso de sucesso retorna o status HTTP 200 (ok) com a seguinte mensagem:
      #   # Response
      #     "message":  questão {nome da questão} deletada com sucesso"
      #
      # Em caso de erro, é renderizada uma mensagem de erro com o status HTTP 400.

      def delete
        question = Question.find(params[:id])
        question.destroy!
        render json: { message: 'questão deletada com sucesso' }, status: :ok
      rescue StandardError => e
        render json: e, status: :bad_request
      end

      # Metodo privado que so tera acesso pela classe Quiz

      private

      # Retorna um hash sanitizado de parâmetros de quiz para criar, atualizar ou deletar uma questão.
      #
      # O hash inclui as seguintes chaves:
      # - title: o tirulo da questão (string)
      # - description: descrição da questão (string)
      # - subject: a materia da questão (string)
      # - answer: resposta da questão (string)
      # - user_id: a que usuario aquela questão esta atrelada (int)
      #
      # Exemplo de uso:
      #   def create
      #     question = Question.new(question_params)
      #     # ...
      #   end
      #
      # Retorna: um hash de parâmetros da questão sanitizados

      def question_params
        params.require(:question).permit(:title, :description, :subject, :answer, :user_id)
      end
    end
  end
end
