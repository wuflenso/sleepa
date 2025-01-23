class SleepsController < ApplicationController
  include HandleControllerErrors

  before_action :set_sleep, only: %i[ show update delete ]

  # GET /sleeps
  def index
    render json: Sleep.get_sleeps(params.expect(:user_id))
  end

  # GET /sleeps/1
  def show
    render json: @sleep
  end

  # GET /sleeps/followings?user_id=:user_id
  def followings
    user_ids = Follower.get_followings_user_ids(params.expect(:user_id))
    sleeps = Sleep.bulk_get_last_week_sleep_records(user_ids)
    render json: sleeps
  end

  # POST /sleeps
  def create
    render json: Sleep.clock_in(create_sleep_params), status: :created
  end

  # PATCH/PUT /sleeps/1
  def update
    render json: @sleep.update(update_sleep_params)
  end

  # DELETE /sleeps/1
  def delete
    if @sleep.delete
      render json: @sleep
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
    params.permit([ :start, :end ])
  end
end
