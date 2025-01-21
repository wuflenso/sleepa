require 'rails_helper'

RSpec.describe Follower, type: :model do
  let(:user_id) { 1 }
  let(:follower_user_id) { 2 }
  let(:followed_at) { Time.new(2025, 1, 25, 7, 0, 0).in_time_zone('Jakarta') }

  subject { Follower.new(user_id: user_id, follower_user_id: follower_user_id, is_active: true, followed_at: followed_at) }

  before do
    allow_any_instance_of(Follower).to receive(:save!).and_return(true)
  end

  describe 'class methods' do
    context '.get_followers' do
      let(:followers) { double('followers') }
      let(:followers_unordered) { double('followers') }

      it 'success get followers' do
        expect(Follower).to receive(:where).with(user_id: user_id).and_return(followers)
        expect(followers).to receive(:where).with(is_active: true).and_return(followers_unordered)
        expect(followers_unordered).to receive(:order).with(followed_at: 'desc').and_return([])

        Follower.get_followers(user_id)
      end
    end

    context '.get_user_followings' do
      let(:followers) { double('followers') }
      let(:followers_unordered) { double('followers') }

      it 'success get user followings' do
        expect(Follower).to receive(:where).with(follower_user_id: follower_user_id).and_return(followers)
        expect(followers).to receive(:where).with(is_active: true).and_return(followers_unordered)
        expect(followers_unordered).to receive(:order).with(followed_at: 'desc').and_return([])

        Follower.get_user_followings(follower_user_id)
      end
    end

    context '.get_followings_user_ids' do
      let(:followers) { double('followers') }
      let(:followers_unordered) { double('followers') }
      let(:followers_unplucked) do
        [
          Follower.new(user_id: 2, follower_user_id: 1),
          Follower.new(user_id: 3, follower_user_id: 1),
          Follower.new(user_id: 4, follower_user_id: 1)
        ]
      end
      let(:expected_user_ids) { [ 2, 3, 4 ] }

      it 'success get user followings' do
        expect(Follower).to receive(:where).with(follower_user_id: follower_user_id).and_return(followers)
        expect(followers).to receive(:where).with(is_active: true).and_return(followers_unordered)
        expect(followers_unordered).to receive(:order).with(followed_at: 'desc').and_return(followers_unplucked)

        result = Follower.get_followings_user_ids(follower_user_id)
        expect(result).to eq(expected_user_ids)
      end
    end

    context '.get_follower_details' do
      let(:followers) { double('followers') }
      let(:followers_unfiltered) { double('followers') }

      it 'success get follower details' do
        expect(Follower).to receive(:where).with(user_id: user_id).and_return(followers)
        expect(followers).to receive(:where).with(follower_user_id: follower_user_id).and_return(followers_unfiltered)
        expect(followers_unfiltered).to receive(:where).with(is_active: true).and_return([ subject ])

        Follower.get_follower_details(user_id, follower_user_id)
      end
    end

    context '.follow' do
      before do
        allow(Follower).to receive(:get_follower_details).with(user_id, follower_user_id).and_return nil
      end

      it 'success create followers instance' do
        follower = Follower.follow(user_id, follower_user_id)
        expect(follower.user_id).to eq(user_id)
        expect(follower.follower_user_id).to eq(follower_user_id)
        expect(follower.followed_at).to be_a(ActiveSupport::TimeWithZone)
        expect(follower.is_active).to eq(true)
      end
    end

    context 'when user already followed' do
      before do
        allow(Follower).to receive(:get_follower_details).with(user_id, follower_user_id).and_return(subject)
      end

      it 'raise error' do
        expect { Follower.follow(user_id, follower_user_id) }.to raise_error(StandardError)
      end
    end
  end

  context '.unfollow' do
    it 'success change is_active state to false' do
      expect(subject.unfollow.is_active).to eq(false)
    end
  end
end
