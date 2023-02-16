require 'rails_helper'

RSpec.describe 'Api::V1::Teams', type: :request do
   # Teste da rota GET /api/v1/team/index
  describe '/GET #index' do
    it 'return http status OK' do
      get '/api/v1/team/index'
      expect(response).to have_http_status(:ok)
    end

    it 'returns a JSON' do
      get '/api/v1/team/index'
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end
  # Teste da rota GET /api/v1/team/show/:id
  describe '/GET #show' do
    it 'if team is found' do
      team = create(:team)
      get "/api/v1/team/show/#{team.id}"
      expect(response).to have_http_status(:ok)
    end

    it 'if team not exist' do
      get '/api/v1/team/show/-1'
      expect(response).to have_http_status(:not_found)
    end
  end
  # Teste da rota POST /api/v1/team/create
  describe '/GET #create' do
    let(:user) { create(:user) }
    let(:team_params) do
      { name: 'teste', user_id: user.id }
    end

    context 'with ok params' do
      it 'return http status created' do
        post '/api/v1/team/create', params: { team: team_params }, headers: {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
        }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with bad params' do
      it 'returns http status bad request' do
        team_params = nil
        post '/api/v1/user/create', params: { contact: team_params }, headers: {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
        }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
  # Teste da rota PATCH /api/v1/team/update/:id
  describe 'PATCH #update' do
    let(:user) { create(:user) }
    let(:team_params) do
      { name: 'teste', user_id: user.id }
    end
    let(:team) { create(:team, name: 'teste2') }

    context 'with ok params' do
      it 'return http status ok' do
        patch "/api/v1/team/update/#{team.id}", params: { team: team_params }, headers: {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
        }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with bad params' do
      it 'returns http status bad request' do
        team_params = nil
        patch '/api/v1/team/update/54', params: { team: team_params }, headers: {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  # Teste da rota DELETE /api/v1/team/delete/:id
  describe '/DELETE #delete' do
    let(:user) { create(:user) }
    let(:team) { create(:team) }

    context 'when team exist' do
      it 'return http status ok' do
        delete "/api/v1/team/delete/#{team.id}", headers: {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
        }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when team not exist' do
      it 'return bad request' do
        delete '/api/v1/team/delete/999', headers: {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
        }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
