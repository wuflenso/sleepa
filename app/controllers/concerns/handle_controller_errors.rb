module HandleControllerErrors
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::ParameterMissing, with: :handle_bad_request

    rescue_from ActiveRecord::RecordInvalid, with: :handle_unprocessable_entity
    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
    rescue_from ActiveRecord::ConnectionNotEstablished, with: :handle_internal_server_error # might need to narrow down
  end

  private

  def handle_internal_server_error(exception)
    error_log = "Internal Server Error: #{exception.message}\nBacktrace:\n#{exception.backtrace.join("\n")}"
    Rails.logger.error(error_log)

    render json: { error: "Internal server error" }, status: :internal_server_error
  end

  def handle_bad_request(exception)
    render json: { error: exception.message }, status: :bad_request
  end

  def handle_unprocessable_entity(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def handle_not_found(exception)
    render json: { error: "Record not found" }, status: :not_found
  end
end
