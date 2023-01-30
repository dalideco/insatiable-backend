# placed in module v1
module V1
  # Controller for players
  class PlayersController < ApplicationController
    before_action :authorize_request, except: %i[create]
    rescue_from ::ActiveRecord::RecordNotUnique, with: :existing_email

    def index
      render json: Player.all
    end

    def create
      @player = Player.new(player_create_params)
      if @player.valid?
        @player.save
        render json: @player
      else
        render status: :bad_request, json: { 'messages' => @player.errors.messages }
      end
    end

    def update
      player = Player.find(params[:id])
      player.update(player_update_params)
      render json: player
    end

    def show
      player = Player.find(params[:id])
      Rails.logger.info player.offers
      Rails.logger.info player.owned_weapons
      render json: player
    end

    private

    def player_create_params
      params.require(:email)
      params.require(:password)
      params.require(:password_confirmation)
      params.permit(:email, :password, :password_confirmation)
    end

    def player_update_params
      params.require(:player).permit(:email, :password)
    end

    def existing_email(exception)
      render status: :conflict,
             json: { 'error' => 'Email already exists', 'messages' => { 'email' => [exception.message] } }
      nil
    end
  end
end
