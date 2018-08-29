require 'rails_helper'

describe 'GET /api/v1/targets/:id', type: :request do
  let(:user)   { create(:user) }
  let(:target) { create(:target, user: user) }

  context 'without being signed in' do
    it 'returns unauthorized' do
      get api_v1_target_path(target.id), as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'being signed in' do
    it 'returns success' do
      get api_v1_target_path(target.id), headers: auth_headers, as: :json

      expect(response).to have_http_status(:success)
    end

    it 'returns the target' do
      get api_v1_target_path(target.id), headers: auth_headers, as: :json

      expect(json[:target]).to include(
        id:        target[:id],
        topic:     target[:topic],
        title:     target[:title],
        latitude:  target[:latitude],
        longitude: target[:longitude]
      )
    end
  end

  context 'being signed in with another user' do
    let(:other_user)   { create(:user) }
    let(:other_target) { create(:target, user: other_user) }

    it 'returns not found' do
      get api_v1_target_path(other_target.id), headers: auth_headers, as: :json

      expect(response).to have_http_status(:not_found)
    end

    it 'does not return the target' do
      get api_v1_target_path(other_target.id), headers: auth_headers, as: :json

      expect(json[:target]).not_to be
    end
  end
end
