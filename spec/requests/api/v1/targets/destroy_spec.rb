require 'rails_helper'

describe 'DELETE api/v1/targets/:id' do
  let(:user)    { create(:user) }
  let!(:target) { create(:target, user: user) }

  context 'without being signed in' do
    it 'returns unauthorized' do
      delete api_v1_target_path(target.id), as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'being signed in' do
    it 'returns success' do
      delete api_v1_target_path(target.id), headers: auth_headers, as: :json

      expect(response).to have_http_status(:no_content)
    end

    it 'deletes the target' do
      expect do
        delete api_v1_target_path(target.id), headers: auth_headers, as: :json
      end.to change(Target, :count).by(-1)
    end
  end

  context 'being signed in with another user' do
    let(:other_user)    { create(:user) }
    let!(:other_target) { create(:target, user: other_user) }

    it 'does not delete the target' do
      expect do
        delete api_v1_target_path(other_target.id), headers: auth_headers, as: :json
      end.to_not change(Target, :count)
    end

    it 'returns not found' do
      delete api_v1_target_path(other_target.id), headers: auth_headers, as: :json

      expect(response).to have_http_status(:not_found)
    end
  end
end
