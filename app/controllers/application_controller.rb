class ApplicationController < ActionController::API
  rescue_from ::ActionController::ParameterMissing, with: :missing_parameter

  def missing_parameter(exception)
    render status: :bad_request, json: { 'error' => 'Bad request', 'message' => exception.message }
    nil
  end
end
