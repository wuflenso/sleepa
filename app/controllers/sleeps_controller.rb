class SleepsController < ApplicationController
  include ControllerResponseBuilder
  include HandleControllerErrors

  wrap_parameters false
  before_action :set_sleep, only: %i[ show update delete ]

  # GET /sleeps
  def index
    params = index_params
    relation = Sleep.get_sleeps(params[:user_id])
    response = Sleep.paginated(relation, params[:limit], params[:offset])
    render json: build_paginated_success_response(response)
  end

  # GET /sleeps/:id
  # Show sleep detail
  def show
    render json: build_success_response(@sleep)
  end

  # GET /sleeps/followings?user_id=:user_id
  def followings
    params = followings_params
    user_ids = Follower.get_followings_user_ids(params[:user_id])
    relation = Sleep.bulk_get_last_week_sleep_records(user_ids)
    response = Sleep.paginated(relation, params[:limit], params[:offset])
    render json: build_paginated_success_response(response)
  end

  # POST /sleeps
  def create
    response = Sleep.clock_in(create_sleep_params)
    render json: build_success_response(response), status: :created
  end

  # PATCH /sleeps/1
  def update
    response = @sleep.update(update_sleep_params)
    render json: build_success_response(response)
  end

  # DELETE /sleeps/:id
  # Delete sleep
  def delete
    if @sleep.delete
      render json: build_success_response(@sleep)
    end
  end

  private
  def set_sleep
    @sleep = Sleep.find(params.expect(:id))
  end

  def create_sleep_params
    params.permit([ :start, :end, :user_id ])
  end

  def update_sleep_params
    params.permit(:id, :start, :end)
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
