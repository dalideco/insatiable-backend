module V1
  # adding owns controller
  class OwnsController < ApplicationController
    before_action :authorize_request
    before_action :find_own, except: %i[create index]
    before_action :allow_edit, only: %i[update destroy]

    def index
      render json: Own.all
    end

    def create
      @own = Own.new(player_id: @current_player.id,
                     weapon_id: own_create_params[:weapon_id])

      if @own.save
        render json: @own
      else
        render status: :bad_request, json: {
          message: @own.errors.messages
        }
      end
    end

    def show
      render json: @own
    end

    def update
      @own.update(own_update_params)
      render @own
    end

    def destroy
      @own.delete
      render json: {
        count: 1,
        message: "Deleted Item with id #{id}"
      }
    end

    private

    def own_create_params
      params.permit(:weapon_id)
    end

    def own_update_params
      params.permit(:player_id, :weapon_id)
    end

    def allow_edit
      return unless @current_player.id != @own.player_id

      render status: :unauthorized, json: {
        message: "This item doesn't belong to player #{@current_player.id}"
      }
    end

    def find_own
      @own = Own.find_by!(id: params[:id])
    rescue ::ActiveRecord::RecordNotFound
      render status: :not_found, json: {
        error: "Own with id #{params[:id]} not found"
      }
    end
  end
end
