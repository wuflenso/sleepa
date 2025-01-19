class FollowersController < ApplicationController
  before_action :set_follower, only: %i[ show delete ]
  rescue_from StandardError, with: :handle_internal_server_error

  # GET /followers?user_id=:user_id
  # Get a user's follower list
  def index
    render json: Follower.get_followers(params.expect(:user_id))
  end

  # GET /followers/details?id=:id
  # Get follower details
  def show
    return render json: @follower unless @follower.nil?
    render json: { message: 'Record not found'}, status: :not_found
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
    render json: Follower.follow(params.expect(:user_id), params.expect(:follower_user_id)), status: :created
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
      @follower = Follower.find_by_id(params.expect(:id))
    end

    def handle_internal_server_error(exception)
      error_log = "Internal Server Error: #{exception.message}\nBacktrace:\n#{exception.backtrace.join("\n")}"
      Rails.logger.error(error_log)

      render json: { error: 'Internal server error'}, status: :internal_server_error
    end
end
