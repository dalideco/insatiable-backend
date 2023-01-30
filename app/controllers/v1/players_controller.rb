# placed in module v1
module V1
  # Controller for players
  class PlayersController < ApplicationController
    before_action :authorize_request, except: %i[create]
    before_action :find_player, except: %i[create index]
    before_action :authorize_update, only: :update

    rescue_from ::ActiveRecord::RecordNotUnique, with: :existing_email

    def index
      render json: Player.all
    end

    def create
      @player = Player.new(player_create_params)
      if @player.save
        render json: @player
      else
        render status: :bad_request, json: { 'messages' => @player.errors.messages }
      end
    end

    def update
      @player.update(player_update_params)
      render json: @player
    end

    def show
      render json: @player
    end

    # private methods
    private

    def player_create_params
      params.require(:email)
      params.require(:password)
      params.require(:password_confirmation)
      params.permit(:email, :password, :password_confirmation)
    end

    def player_update_params
      params.permit(:avatar)
    end

    def existing_email(exception)
      render status: :conflict,
             json: { 'error' => 'Email already exists', 'messages' => { 'email' => [exception.message] } }
      nil
    end

    # finds player first
    def find_player
      @player = Player.find_by!(id: params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'User not found' }, status: :not_found
    end

    def authorize_update
      return unless @current_player.id != @player.id
      render status: :unauthorized, json: {
        error: 'Cannot update a different user'
      }
    end
  end
end
