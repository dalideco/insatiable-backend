# placed in module v1
module V1
  # Controller for players
  class PlayersController < ApplicationController
    # Authentication
    before_action :authorize_request, except: %i[create]
    # finding player
    before_action :find_player, except: %i[create index]
    # checking if player has the right to update
    before_action :authorize_update, only: :update

    # Email already exists rescue
    rescue_from ::ActiveRecord::RecordNotUnique, with: :existing_email

    def index
      render json: Player.all.as_json
    end

    def create
      @player = Player.new(player_create_params)
      if @player.save
        render json: @player.as_json
      else
        render status: :bad_request, json: { 'messages' => @player.errors.messages }
      end
    end

    def update
      @player.update(player_update_params)
      render json: @player.as_json
    end

    def show
      render json: @player.as_json
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
