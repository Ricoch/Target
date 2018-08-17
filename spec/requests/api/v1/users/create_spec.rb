require 'rails_helper'

describe 'POST api/v1/users/', type: :request do
  let(:user) { User.last }

  describe 'POST create' do
    let(:email)                 { 'test@test.com' }
    let(:password)              { '12345678' }
    let(:password_confirmation) { '12345678' }

    let(:params) do
      {
        user: {
          email: email,
          password: password,
          password_confirmation: password_confirmation
        }
      }
    end

    it 'returns a successful response' do
      post user_registration_path, params: params, as: :json

      expect(response).to have_http_status(:success)
    end

    it 'creates the user' do
      expect do
        post user_registration_path, params: params, as: :json
      end.to change(User, :count).by(1)
    end

    it 'returns the user' do
      post user_registration_path, params: params, as: :json

      expect(json[:user]).to include(
        id: user.id,
        email: user.email,
        uid: user.uid,
        provider: 'email'
      )
    end

    context 'when the email is not correct' do
      let(:email) { 'invalid_email' }

      it 'does not create a user' do
        expect do
          post user_registration_path, params: params, as: :json
        end.not_to change { User.count }
      end

      it 'does not return a successful response' do
        post user_registration_path, params: params, as: :json

        expect(response).to_not have_http_status(:success)
      end
    end

    context 'when the password is incorrect' do
      let(:password)              { 'short' }
      let(:password_confirmation) { 'short' }
      let(:new_user)              { User.find_by_email(email) }

      it 'does not create a user' do
        post user_registration_path, params: params, as: :json

        expect(new_user).to_not be
      end

      it 'does not return a successful response' do
        post user_registration_path, params: params, as: :json

        expect(response).to_not have_http_status(:success)
      end
    end

    context 'when passwords don\'t match' do
      let(:password)              { 'shouldmatch' }
      let(:password_confirmation) { 'dontmatch' }
      let(:new_user)              { User.find_by_email(email) }

      it 'does not create a user' do
        post user_registration_path, params: params, as: :json

        expect(new_user).to_not be
      end

      it 'does not return a successful response' do
        post user_registration_path, params: params, as: :json

        expect(response).to_not have_http_status(:success)
      end
    end
  end
end
