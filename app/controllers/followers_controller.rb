class FollowersController < ApplicationController
  include HandleControllerErrors

  before_action :set_follower, only: %i[ show delete ]

  # GET /followers?user_id=:user_id
  # Get a user's follower list
  def index
    render json: Follower.get_followers(params.expect(:user_id))
  end

  # GET /followers/details?id=:id
  # Get follower details
  def show
    render json: @follower
  end

  # GET /followers/followings
  # Get a user's following list
  def followings
    render json: Follower.get_user_followings(params.expect(:user_id))
  end

  # POST /followers/follow
  # Follow a user
  # Request body params:
  # user_id bigint
  # follower_user_id bigint
  def create
    params = create_params
    render json: Follower.follow(params[:user_id], params[:follower_user_id]), status: :created
  end

  # DELETE /followers/unfollow/:id
  # Unfollow a user
  def delete
    if @follower.unfollow
      render json: @follower
    end
  end

  private
    def set_follower
      @follower = Follower.find(params.expect(:id))
    end

    def create_params
      params.expect(:user_id, :follower_user_id)
    end
end
