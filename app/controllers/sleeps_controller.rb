class SleepsController < ApplicationController
  rescue_from StandardError, with: :handle_internal_server_error
  rescue_from ActiveRecord::RecordInvalid, with: :handle_unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

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

    def handle_internal_server_error(exception)
      error_log = "Internal Server Error: #{exception.message}\nBacktrace:\n#{exception.backtrace.join("\n")}"
      Rails.logger.error(error_log)

      render json: { error: 'Internal server error'}, status: :internal_server_error
    end

    def handle_unprocessable_entity(exception)
      render json: { error: exception.message }, status: :unprocessable_entity
    end

    def handle_not_found(exception)
      render json: { error: "Record not found" }, status: :not_found
    end
end
