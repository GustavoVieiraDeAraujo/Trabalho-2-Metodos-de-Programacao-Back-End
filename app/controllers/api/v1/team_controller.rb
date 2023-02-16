module Api
  module V1
    # Controlador para gerenciar turmas.
    class TeamController < ApplicationController
      # Autentica o token de autenticação do usuario para as ações de create, delete e update.
      acts_as_token_authentication_handler_for User, only: %i[create delete update add_user_to_team remove_user_from_team]

      # ==== Ação para listar todos as turmas cadastrados no sistema.
      #
      # Busca por todos as turmas no banco de dados.
      #
      # ==== Exemplo de uso:
      #
      #   GET /team
      #
      # Retorna um objeto JSON com os dados de todos as turmas e um status HTTP 200 (OK).
      # Se a turma não existir, retorna um status HTTP 400(bad_request)
      #
      # ==== Raises:
      # - StandardError: se ocorrer um erro durante a listagem .
      #

      def index
        team = Team.all
        render json: team, status: :ok
      rescue StandardError => e
        render json: e, status: :bad_request
      end

      # ==== Ação para exibir as informações de uma turma pelo ID.
      #
      # Busca pelo ID especifico da turma.
      #
      # ==== Exemplo de uso:
      #
      #   GET /team/:id
      #
      # Retorna um objeto JSON com as informações da turma e um status HTTP 200 (OK).
      # Se o turma não existir, retorna um status HTTP 404 (Not Found).
      #
      # ==== Raises:
      # - StandardError: se ocorrer um erro durante a busca.
      #

      def show
        team = Team.find(params[:id])
        render json: team, status: :ok
      rescue StandardError => e
        render json: e, status: :not_found
      end

      # ==== Ação para criar uma turma.
      #
      # Utiliza os parametros necessários para cria um turma.
      #
      # ==== Exemplo de uso:
      #
      #   POST /team
      #   params: { name: 'user', user_id: id }
      #
      # Cria uma nova turma com os parâmetros passados e retorna um objeto JSON com as informações da turma criado e um status HTTP 201 (Created).
      # Caso os devidos paremetros não exisita retorna o status de 400 (bad_request)
      #
      # Raises:
      # - StandardError: se ocorrer um erro durante a criação do turma.
      #

      def create
        team = Team.create!(team_params)
        team.save!
        render json: team, status: :created
      rescue StandardError => e
        render json: e, status: :bad_request
      end

      # ==== Ação para atualizar as informações de uma turma.
      #
      # Busca pela ID específica da turma para atualiza-la
      #
      # ==== Exemplo de uso:
      #
      #   PUT /team/:id
      #   params: { name: 'user', user_id: id }
      #
      #
      # Atualiza as informações da turma com os parâmetros passados e retorna um objeto JSON com as informações do turma atualizado e um status HTTP 200 (OK).
      # Se a turma não existir, retorna um status HTTP 422 (unprocessable_entity).
      #
      # ==== Raises:
      # - StandardError: se ocorrer um erro durante a atualização do turma.
      #

      def update
        team = Team.find(params[:id])
        team.update!(team_params)
        render json: team, status: :ok
      rescue StandardError => e
        render json: e, status: :unprocessable_entity
      end

      # Método para excluir uma turma do banco de dados
      #
      # Exemplo de uso:
      #
      #   DELETE /team/:id
      #
      # Em caso de sucesso retorna o status HTTP 200 (ok) com a seguinte mensagem:
      #   # Response
      #     "message": "Turma {nome da turma} deletada com sucesso"
      #
      # Em caso de erro, é renderizada uma mensagem de erro com o status HTTP 400.

      def delete
        team = Team.find(params[:id])
        team.destroy!
        render json: { message: "Turma #{team.name} deletada com sucesso" }, status: :ok
      rescue StandardError => e
        render json: e, status: :bad_request
      end

      # Adiciona um aluno a uma turma
      def add_user_to_team
        team = Team.find(params[:team_id])
        user = User.find(params[:user_id])
        StudentTeam.create!(user: user, team: team)
        render json: { message: "#{user.name} adicionado a turma #{team.name}" }, status: :ok
      rescue StandardError => e
        render json: { error: e.message }, status: :bad_request
      end

      # Remove um aluno de uma turma
      def remove_user_from_team
        student_team = StudentTeam.find_by!(user_id: params[:user_id], team_id: params[:team_id])
        student_team.destroy!
        render json: { message: "Aluno removido da turma com sucesso" }, status: :ok
      rescue StandardError => e
        render json: { error: e.message }, status: :bad_request
      end

      private

      # Retorna um hash sanitizado de parâmetros de team para criar, atualizar ou deletar uma turma.
      #
      # O hash inclui as seguintes chaves:
      # - name: o nome da turma (string)
      # - user_id: a que usuario aquela turma esta atrelada (int)
      #
      # Exemplo de uso:
      #   def create
      #     team = Team.new(team_params)
      #     # ...
      #   end
      #
      # Retorna: um hash de parâmetros da turma sanitizados

      def team_params
        params.require(:team).permit(:name, :user_id)
      end
    end
  end
end
