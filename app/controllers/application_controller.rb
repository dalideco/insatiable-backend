# Main application controller
class ApplicationController < ActionController::API
  rescue_from ::ActionController::ParameterMissing, with: :missing_parameter

  def missing_parameter(exception)
    render status: :bad_request, json: { 'error' => 'Bad request', 'message' => exception.message }
    nil
  end

  # authorizes request
  def authorize_request
    # get token from header
    header = request.headers['Authorization']
    header = header.split(' ').last if header

    begin
      @decoded = JsonWebToken.decode(header)
      @current_player = V1::Player.find_by(id: @decoded[:player_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
