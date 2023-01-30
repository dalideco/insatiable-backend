module V1
  # authentication controller
  class AuthController < ApplicationController
    def login
      @player = Player.find_by(email: login_params[:email])

      if @player&.authenticate(login_params[:password])
        token = JsonWebToken.encode(player_id: @player.id)
        time = Time.zone.now + 24.hours.to_i
        render json: { token:, exp: time.strftime('%m-%d-%Y %H:%M'),
                       email: @player.email }, status: :ok
      else
        render status: :unauthorized, json: { 'error' => 'Unauthorized' }
      end
    end

    private

    def login_params
      params.require(:email)
      params.require(:password)
      params.permit(:email, :password)
    end
  end
end
