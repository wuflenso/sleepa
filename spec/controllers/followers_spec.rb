require 'rails_helper'

RSpec.describe FollowersController, type: :controller do
  describe 'index' do
    subject { get :index, params: http_params }

    let(:http_params) do
      {
        user_id: 1
      }
    end

    context 'when success' do
      before do
        allow(Follower).to receive(:get_followers).with(anything).and_return([ Follower.new ])
      end

      it 'success get followers and does not return error' do
        expect { subject }.not_to raise_error
        expect(response).to have_http_status(200)
      end
    end

    context 'when encounter unexpected error' do
      before do
        allow(Follower).to receive(:get_followers).and_raise(ActiveRecord::ConnectionNotEstablished)
      end

      it 'returns internal server error' do
        subject
        expect(response).to have_http_status(500)
      end
    end
  end

  describe 'show' do
    subject { get :show, params: http_params }

    let(:http_params) do
      {
        id: 1
      }
    end

    context 'when success' do
      before do
        allow(Follower).to receive(:find).with(anything).and_return(Follower.new)
      end

      it 'success get follower detail and does not return error' do
        expect { subject }.not_to raise_error
        expect(response).to have_http_status(200)
      end
    end

    context 'when record is not found' do
      before do
        allow(Follower).to receive(:find).with(anything).and_raise(ActiveRecord::RecordNotFound)
      end

      it 'returns not found' do
        subject
        expect(response).to have_http_status(404)
      end
    end

    context 'when encounter unexpected error' do
      before do
        allow(Follower).to receive(:find).and_raise(ActiveRecord::ConnectionNotEstablished)
      end

      it 'returns internal server error' do
        subject
        expect(response).to have_http_status(500)
      end
    end
  end

  describe 'followings' do
    subject { get :followings, params: http_params }

    let(:http_params) do
      {
        user_id: 1
      }
    end

    context 'when success' do
      before do
        allow(Follower).to receive(:get_user_followings).with(anything).and_return([ Follower.new ])
      end

      it 'success get followings and does not return error' do
        expect { subject }.not_to raise_error
        expect(response).to have_http_status(200)
      end
    end

    context 'when encounter unexpected error' do
      before do
        allow(Follower).to receive(:get_user_followings).and_raise(ActiveRecord::ConnectionNotEstablished)
      end

      it 'returns internal server error' do
        subject
        expect(response).to have_http_status(500)
      end
    end
  end

  describe 'create' do
    subject { post :create, params: http_params }

    let(:http_params) do
      {
        user_id: 1,
        follower_user_id: 2
      }
    end

    context 'when success' do
      before do
        allow(Follower).to receive(:follow).with(anything, anything).and_return(Follower.new)
      end

      it 'success create and does not return error' do
        expect { subject }.not_to raise_error
        expect(response).to have_http_status(201)
      end
    end

    context 'when encounter record invalid error' do
      before do
        allow(Follower).to receive(:follow).with(anything, anything).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'return unprocessable entity error' do
        subject
        expect(response).to have_http_status(422)
      end
    end

    context 'when encounter unexpected error' do
      before do
        allow(Follower).to receive(:follow).with(anything, anything).and_raise(ActiveRecord::ConnectionNotEstablished)
      end

      it 'returns internal server error' do
        subject
        expect(response).to have_http_status(500)
      end
    end
  end

  describe 'delete' do
    subject { delete :delete, params: http_params }

    let(:http_params) do
      {
        id: 1
      }
    end

    before do
      allow(Follower).to receive(:find).with(anything).and_return(Follower.new)
    end

    context 'when success' do
      before do
        allow_any_instance_of(Follower).to receive(:unfollow).and_return(Follower.new)
      end

      it 'success get follower detail and does not return error' do
        expect { subject }.not_to raise_error
        expect(response).to have_http_status(200)
      end
    end

    context 'when encounter unexpected error' do
      before do
        allow_any_instance_of(Follower).to receive(:unfollow).and_raise(ActiveRecord::ConnectionNotEstablished)
      end

      it 'returns internal server error' do
        subject
        expect(response).to have_http_status(500)
      end
    end
  end
end
