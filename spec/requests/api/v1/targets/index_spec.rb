require 'rails_helper'

describe 'GET /api/v1/targets/', type: :request do
  let(:user)                { create(:user) }
  let!(:targets)            { create_list(:target, 3, user: user) }

  context 'without being signed in' do
    it 'returns unauthorized' do
      get api_v1_targets_path, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'being signed in' do
    let(:first_actual_target) { json[:targets].first }

    it 'returns success' do
      get api_v1_targets_path, headers: auth_headers, as: :json

      expect(response).to have_http_status(:success)
    end

    it 'returns user\'s targets' do
      get api_v1_targets_path, headers: auth_headers, as: :json

      expect(json[:targets].count).to eq(3)
    end

    it 'returns target info' do
      get api_v1_targets_path, headers: auth_headers, as: :json
      first_target = targets.first

      expect(first_actual_target).to include(
        id:        first_target.id,
        title:     first_target.title,
        radius:    first_target.radius,
        topic:     first_target.topic,
        latitude:  first_target.latitude,
        longitude: first_target.longitude
      )
    end
  end
end
