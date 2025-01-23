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
    context '.paginated' do
      let(:relation) { double }
      let(:relation_offset) { double }

      before do
        allow(relation).to receive(:count).and_return(2)
        allow(relation).to receive(:offset).and_return(relation_offset)
        allow(relation_offset).to receive(:limit).and_return(relation)
      end

      it 'success get followers' do
        response = Sleep.paginated(relation, 10, 0)
        expect(response).to eq([ relation, 2 ])
      end
    end

    describe '.get_sleeps' do
      let(:sleeps) { double('sleeps') }
      let(:sleeps_unordered) { double('sleeps') }

      it 'success get sleeps' do
        expect(Sleep).to receive(:where).with(user_id: user_id).and_return(sleeps)
        expect(sleeps).to receive(:where).with(deleted_at: nil).and_return(sleeps_unordered)
        expect(sleeps_unordered).to receive(:order).with(start: 'desc').and_return([ subject ])

        Sleep.get_sleeps(user_id)
      end
    end

    describe '.clock_in' do
      let(:params) do
        {
          user_id: user_id,
          start: start_time
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

    describe '.bulk_get_last_week_sleep_records' do
      let(:followings_user_ids) { [ 2, 3, 4, 5, 6 ] }
      let(:sleeps) { double('sleeps') }
      let(:sleeps_active) { double('sleeps') }
      let(:sleeps_unordered) { double('sleeps') }

      context 'when query result is not empty' do
        it 'success get followed users sleep records ordered' do
          expect(Sleep).to receive(:where).with(user_id: followings_user_ids).and_return(sleeps)
          expect(sleeps).to receive(:where).with(deleted_at: nil).and_return(sleeps_active)
          expect(sleeps_active).to receive(:where).with(start: anything).and_return(sleeps_unordered)
          expect(sleeps_unordered).to receive(:order).with(duration_seconds: 'desc').and_return([ subject ])

          Sleep.bulk_get_last_week_sleep_records(followings_user_ids)
        end
      end

      context 'when query returns nil' do
        it 'success get followed users sleep records ordered' do
          expect(Sleep).to receive(:where).with(user_id: followings_user_ids).and_return(nil)

          results = Sleep.bulk_get_last_week_sleep_records(followings_user_ids)
          expect(results).to eq([])
        end
      end
    end
  end

  describe '.update' do
    let(:updated_start_time) { "2023-01-25T22:00:00+0700" }
    let(:updated_end_time) { "2023-01-26T05:00:00+0700" }
    let(:params) do
      {
        start: updated_start_time,
        end: updated_end_time
      }
    end

    it 'success update sleep' do
      sleep_record = subject.update(params)
      expect(sleep_record.user_id).to eq(user_id)
      expect(sleep_record.start).to eq(updated_start_time)
      expect(sleep_record.end).to be_a(ActiveSupport::TimeWithZone)
      expect(sleep_record.end).to eq(updated_end_time)
      expect(sleep_record.end).not_to eq(end_time)
      expect(sleep_record.duration_seconds).to be > 0
    end
  end

  describe '.delete' do
    it 'success change deleted_at to not nil' do
      expect(subject.delete.deleted_at).to be_a(ActiveSupport::TimeWithZone)
    end
  end
end
