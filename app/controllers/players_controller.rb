# players controller
class PlayersController < ApplicationController
  rescue_from ::ActiveRecord::RecordNotUnique, with: :existing_email

  def index
    render json: Player.all
  end

  def create
    Rails.logger.info 'test'
    Rails.logger.info player_params
    @player = Player.create(player_params)

    render json: @player
  end

  def update
    player = Player.find(params[:id])
    player.update(player_params)
    render json: player
  end

  def show
    player = Player.find(params[:id])
    Rails.logger.info player.offers
    Rails.logger.info player.owned_weapons
    render json: player
  end

  private

  def player_params
    params.require(:email)
    params.require(:password)
    params.require(:player).permit(:email, :password)
  end

  def existing_email(exception)
    render status: :conflict, json: { 'error' => 'Email already exists', 'message' => exception.message }
    nil
  end
end
