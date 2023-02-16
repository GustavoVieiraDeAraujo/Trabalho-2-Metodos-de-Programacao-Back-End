require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  # Teste da rota POST /api/v1/user/login
  describe 'user login' do
    before do
      create(:user, email: 'teste@teste', password: '1234567')
    end
    context 'when user has no a valid email' do
      it 'return http status unauthorized' do
        post '/api/v1/user/login', params: {
          email: 'teste@teste.com',
          password: '1234567'
        }
        expect(response).to have_http_status(:unauthorized)
      end
    end
    context 'when user has no a valid password' do
      it 'return http status unauthorized' do
        post '/api/v1/user/login', params: {
          email: 'teste@teste',
          password: '-1'
        }
        expect(response).to have_http_status(:unauthorized)
      end
    end
    # Teste da rota DELETE /api/v1/user/logout
    context 'when login is a success' do
      it 'return http status ok' do
        post '/api/v1/user/login', params: {
          email: 'teste@teste',
          password: '1234567'
        }
        expect(response).to have_http_status(:ok)
      end
    end
  end
  describe 'user logout' do
    let(:user) { create(:user) }
    before do
      post '/api/v1/user/login', params: {
        email: 'teste@teste',
        password: '1234567'
      }
    end
    context 'when user is loged' do
      it 'return http status ok' do
        delete '/api/v1/user/logout', headers: {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
        }
        expect(response).to have_http_status(:ok)
      end
    end
  end
  # Teste da rota GET /api/v1/user/index
  describe '/GET #index' do
    it 'return http status OK' do
      get '/api/v1/user/index'
      expect(response).to have_http_status(:ok)
    end
    it 'returns a JSON' do
      get '/api/v1/user/index'
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end
  # Teste da rota GET /api/v1/user/show/:id
  describe '/GET #show' do
    it 'if user exist' do
      user = create(:user)
      get "/api/v1/user/show/#{user.id}"
      expect(response).to have_http_status(:ok)
    end
    it 'if user not exist' do
      get '/api/v1/user/show/-1'
      expect(response).to have_http_status(:not_found)
    end
  end
  # Teste da rota PATCH /api/v1/user/create
  describe '/GET #create' do
    let(:user) { create(:user) }
    let(:statistic) { create(:statistic) }
    let(:user_params) do
      { name: 'teste', enrollment: 12_345_678, is_admin: true, is_student: false, is_teacher: false, email: 'teste@teste',
        password: '123456782', statistic_id: statistic.id }
    end
    context 'with ok params' do
      it 'return http status created' do
        post '/api/v1/user/create', params: { user: user_params }, headers: {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
        }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with bad params' do
      it 'returns http status bad request' do
        user_params = nil
        post '/api/v1/user/create', params: { contact: user_params }, headers: {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
        }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
    # Teste da rota PATCH /api/v1/user/update/:id
  describe 'PATCH #update' do
    let(:statistic) { create(:statistic) }
    let(:user_params) do
      { name: 'teste', enrollment: 12_345_678, is_admin: true, is_student: false, is_teacher: false, email: 'teste@teste',
        password: '123456782', statistic_id: statistic.id }
    end
    let(:user) { create(:user, name: 'teste2') }
    context 'with ok params' do
      it 'return http status ok' do
        patch "/api/v1/user/update/#{user.id}", params: { user: user_params }, headers: {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
        }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with bad params' do
      it 'returns http status bad request' do
        user_params = nil
        patch '/api/v1/user/update/-1', params: { user: user_params }, headers: {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  # Teste da rota DELETE /api/v1/user/delete/:id
  describe '/DELETE #delete' do
    let(:user) { create(:user) }
    context 'when user exist' do
      it 'return http status ok' do
        delete "/api/v1/user/delete/#{user.id}", headers: {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
        }
        expect(response).to have_http_status(:ok)
      end
    end
    context 'when user not exist' do
      it 'return bad request' do
        delete '/api/v1/user/delete/-1', headers: {
          'X-User-Email': user.email,
          'X-User-Token': user.authentication_token
        }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
