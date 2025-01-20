class SleepsController < ApplicationController
  include HandleControllerErrors

  before_action :set_sleep, only: %i[ show update delete ]

  # GET /sleeps
  def index
    render json: Sleep.get_sleeps(params.expect(:user_id))
  end

  # GET /sleeps/1
  def show
    return render json: @sleep unless @sleep.nil?
    render json: { message: 'Record not found'}, status: :not_found
  end

  # POST /sleeps
  def create
    render json: Sleep.clock_in(sleep_params), status: :created
  end

  # PATCH/PUT /sleeps/1
  def update
    render json: @sleep.update(sleep_params)
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

  def sleep_params
    params.permit([ :start, :end, :user_id ])
  end
end
