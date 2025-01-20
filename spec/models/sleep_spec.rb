require 'rails_helper'

RSpec.describe Sleep, type: :model do
  let(:user_id) { 1 }
  let(:start_time) { Time.new(2024, 1, 25, 22, 0, 0).in_time_zone('Jakarta') }
  let(:end_time) { Time.new(2024, 1, 26, 5, 0, 0).in_time_zone('Jakarta') }

  subject { Sleep.new(user_id: user_id, start: start_time, end: end_time, duration_seconds: 25200.0) }

  before do
    allow_any_instance_of(Sleep).to receive(:save!).and_return(true)
  end

  describe 'class methods' do
    describe '.get_sleeps' do
      let(:sleeps) { double('sleeps') }
      let(:sleeps_unordered) { double('sleeps') }

      it 'success get sleeps' do
        expect(Sleep).to receive(:where).with(user_id: user_id).and_return(sleeps)
        expect(sleeps).to receive(:where).with(deleted_at: nil).and_return(sleeps_unordered)
        expect(sleeps_unordered).to receive(:order).with(start: 'desc').and_return([subject])

        Sleep.get_sleeps(user_id)
      end
    end

    describe '.clock_in' do
      let(:params) do
        {
          user_id: user_id,
          start: start_time,
        }
      end

      context 'when success' do
        it 'success create sleep' do
          sleep_record = Sleep.clock_in(params)
          expect(sleep_record.user_id).to eq(user_id)
          expect(sleep_record.start).to eq(start_time)
          expect(sleep_record.end).to be_a(ActiveSupport::TimeWithZone)
          expect(sleep_record.duration_seconds).to be > 0
          expect(sleep_record.deleted_at).to eq(nil)
        end
      end
    end
  end

  describe '.delete' do
    it 'success change is_active state to false' do
      expect(subject.delete.deleted_at).to be_a(ActiveSupport::TimeWithZone)
    end
  end
end
