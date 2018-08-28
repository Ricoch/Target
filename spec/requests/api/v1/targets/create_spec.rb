require 'rails_helper'

describe 'POST /api/v1/targets/', type: :request do
  describe 'POST create' do
    let(:radius)       { 300 }
    let(:title)        { 'Test title' }
    let(:latitude)     { -34.9065165 }
    let(:longitude)    { -56.1997675 }
    let(:user)         { create(:user) }
    let(:topic)        { 'football' }
    let(:api_v1_targets_path) { '/api/v1/targets' }

    let(:params) do
      {
        target: {
          user:      user,
          topic:     topic,
          title:     title,
          radius:    radius,
          latitude:  latitude,
          longitude: longitude
        }
      }
    end

    context 'without being signed in' do
      it 'returns unauthorized' do
        post api_v1_targets_path, params: params, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'being signed in' do
      context 'with correct params' do
        it 'returns success' do
          post api_v1_targets_path, params: params, headers: auth_headers, as: :json
          expect(response).to have_http_status(:success)
        end

        it 'creates the target' do
          expect do
            post api_v1_targets_path, params: params, headers: auth_headers, as: :json
          end.to change(Target, :count).by(1)
        end

        it 'returns the target' do
          post api_v1_targets_path, params: params, headers: auth_headers, as: :json
          target = Target.find(json[:target][:id])

          expect(target[:latitude]).to  eq(latitude)
          expect(target[:longitude]).to eq(longitude)
        end
      end

      shared_examples 'it does not allow the action' do
        it 'returns bad request' do
          post api_v1_targets_path, params: params, headers: auth_headers, as: :json
          expect(response).to have_http_status(:bad_request)
        end

        it 'does not save the target' do
          expect do
            post api_v1_targets_path, params: params, headers: auth_headers, as: :json
          end.not_to change(Target, :count)
        end
      end

      context 'with no title' do
        let(:title) {}

        it_behaves_like 'it does not allow the action'
      end

      context 'with no radius' do
        let(:radius) {}

        it_behaves_like 'it does not allow the action'
      end

      context 'with no latitude' do
        let(:latitude) {}

        it_behaves_like 'it does not allow the action'
      end

      context 'with no longitude' do
        let(:longitude) {}

        it_behaves_like 'it does not allow the action'
      end

      context 'with no topic' do
        let(:topic) {}

        it_behaves_like 'it does not allow the action'
      end

      context 'with not a number on radius' do
        let(:radius) { 'not a number ' }

        it_behaves_like 'it does not allow the action'
      end

      context 'with not an int on radius' do
        let(:radius) { 3.1415926535 }

        it_behaves_like 'it does not allow the action'
      end

      context 'with not a number on latitude' do
        let(:latitude) { 'not a number' }

        it_behaves_like 'it does not allow the action'
      end

      context 'with not a number on longitude' do
        let(:longitude) { 'not a number' }

        it_behaves_like 'it does not allow the action'
      end

      context 'with an invalid topic' do
        let(:topic) { 'invalid topic' }

        it_behaves_like 'it does not allow the action'
      end
    end
  end
end
