require 'rails_helper'

RSpec.describe SleepsController, type: :controller do
  describe 'index' do
    subject { get :index, params: http_params }

    let(:http_params) do
      {
        user_id: 1
      }
    end

    context 'when success' do
      before do
        allow(Sleep).to receive(:get_sleeps).with(anything).and_return([ Sleep.new ])
      end

      it 'success get sleeps and does not return error' do
        expect { subject }.not_to raise_error
        expect(response).to have_http_status(200)
      end
    end

    context 'when encounter unexpected error' do
      before do
        allow(Sleep).to receive(:get_sleeps).and_raise(StandardError)
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
        allow(Sleep).to receive(:find).with(anything).and_return(Sleep.new)
      end

      it 'success get sleep detail and does not return error' do
        expect { subject }.not_to raise_error
        expect(response).to have_http_status(200)
      end
    end

    context 'when record is not found' do
      before do
        allow(Sleep).to receive(:find).with(anything).and_raise(ActiveRecord::RecordNotFound)
      end

      it 'returns not found' do
        subject
        expect(response).to have_http_status(404)
      end
    end

    context 'when encounter unexpected error' do
      before do
        allow(Sleep).to receive(:find).and_raise(StandardError)
      end

      it 'returns internal server error' do
        subject
        expect(response).to have_http_status(500)
      end
    end
  end

  describe 'followings' do
    subject { get :followings, params: http_params }

    let(:followings_user_ids) { [ 2, 3, 4, 5, 6 ] }
    let(:http_params) do
      {
        user_id: 1
      }
    end

    context 'when success' do
      before do
        allow(Follower).to receive(:get_followings_user_ids).with(anything).and_return(followings_user_ids)
        allow(Sleep).to receive(:bulk_get_last_week_sleep_records).with(followings_user_ids).and_return([ Sleep.new ])
      end

      it 'success get sleeps and does not return error' do
        expect { subject }.not_to raise_error
        expect(response).to have_http_status(200)
      end
    end

    context 'when encounter unexpected error' do
      before do
        allow(Follower).to receive(:get_followings_user_ids).and_raise(StandardError)
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
        start: Time.new(2024, 1, 25, 22, 0, 0).in_time_zone('Jakarta')
      }
    end

    context 'when success' do
      before do
        allow(Sleep).to receive(:clock_in).with(anything).and_return(Sleep.new)
      end

      it 'success create and does not return error' do
        expect { subject }.not_to raise_error
        expect(response).to have_http_status(201)
      end
    end

    context 'when encounter record invalid error' do
      before do
        allow(Sleep).to receive(:clock_in).with(anything).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'return unprocessable entity error' do
        subject
        expect(response).to have_http_status(422)
      end
    end

    context 'when encounter unexpected error' do
      before do
        allow(Sleep).to receive(:clock_in).with(anything).and_raise(StandardError)
      end

      it 'returns internal server error' do
        subject
        expect(response).to have_http_status(500)
      end
    end
  end

  describe 'update' do
    subject { patch :update, params: http_params }

    let(:http_params) do
      {
        id: 1,
        start: Time.new(2024, 1, 25, 22, 0, 0).in_time_zone('Jakarta'),
        end: Time.new(2024, 1, 26, 22, 0, 0).in_time_zone('Jakarta')
      }
    end

    before do
      allow(Sleep).to receive(:find).with(anything).and_return(Sleep.new)
      allow(Sleep).to receive(:update).with(anything).and_return(Sleep.new)
    end

    context 'when success' do
      before do
        allow_any_instance_of(Sleep).to receive(:update).and_return(Sleep.new)
      end

      it 'success update and does not return error' do
        expect { subject }.not_to raise_error
        expect(response).to have_http_status(200)
      end
    end

    context 'when encounter unexpected error' do
      before do
        allow_any_instance_of(Sleep).to receive(:update).and_raise(StandardError)
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
      allow(Sleep).to receive(:find).with(anything).and_return(Sleep.new)
    end

    context 'when success' do
      before do
        allow_any_instance_of(Sleep).to receive(:delete).and_return(Sleep.new)
      end

      it 'success delete and does not return error' do
        expect { subject }.not_to raise_error
        expect(response).to have_http_status(200)
      end
    end

    context 'when encounter unexpected error' do
      before do
        allow_any_instance_of(Sleep).to receive(:delete).and_raise(StandardError)
      end

      it 'returns internal server error' do
        subject
        expect(response).to have_http_status(500)
      end
    end
  end
end
