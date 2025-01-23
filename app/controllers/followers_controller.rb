class FollowersController < ApplicationController
  include ControllerResponseBuilder
  include HandleControllerErrors

  wrap_parameters false
  before_action :set_follower, only: %i[ show delete ]

  # GET /followers?user_id=:user_id
  # List followers
  def index
    params = index_params
    relation = Follower.get_followers(params[:user_id])
    response = Follower.paginated(relation, params[:limit], params[:offset])
    render json: build_paginated_success_response(response)
  end

  # GET /followers/:id
  # Show followership details
  def show
    render json: build_success_response(@follower)
  end

  # GET /followers/followings?user_id=:user_id
  # List followed users
  def followings
    params = followings_params
    relation = Follower.get_user_followings(params[:user_id])
    response = Follower.paginated(relation, params[:limit], params[:offset])
    render json: build_paginated_success_response(response)
  end

  # POST /followers/follow
  # Follow a user
  # Request Body
  # {
  #   user_id: 1,
  #   follower_user_id: 2
  # }
  def create
    params = create_params
    response = Follower.follow(params[:user_id].to_i, params[:follower_user_id].to_i)
    render json: build_success_response(response), status: :created
  end

  # DELETE /followers/:id/unfollow
  # Unfollow a user
  def delete
    if @follower.unfollow
      render json: build_success_response(@follower)
    end
  end

  private
  def set_follower
    @follower = Follower.find(params.expect(:id))
  end

  def create_params
    {
      user_id: params.expect(:user_id),
      follower_user_id: params.expect(:follower_user_id)
    }
  end

  def index_params
    params.require(:user_id)
    params.permit(:user_id, :limit, :offset).tap do |param|
      param[:limit] ||= 10
      param[:offset] ||= 0
    end
  end

  def followings_params
    params.require(:user_id)
    params.permit(:user_id, :limit, :offset).tap do |param|
      param[:limit] ||= 10
      param[:offset] ||= 0
    end
  end
end
