module V1
  # own pack controller
  # own pack is the relationship between players and packs
  class OwnPacksController < ApplicationController
    before_action :authorize_request
    before_action :find_own_pack, except: %i[create index]
    before_action :allow_edit, only: %i[update destroy]

    def index
      render json: OwnPack.all
    end

    def create
      @own_pack = OwnPack.new(player_id: @current_player.id,
                              pack_id: own_create_params[:pack_id])

      if @own_pack.save
        render json: @own_pack
      else
        render status: :bad_request, json: {
          message: @own_pack.errors.messages
        }
      end
    end

    def show
      render json: @own_pack
    end

    def update
      @own_pack.update(own_update_params)
      render json: @own_pack
    end

    def destroy
      @own_pack.delete
      render json: {
        count: 1,
        message: "Deleted Item with id #{id}"
      }
    end

    private

    def own_create_params
      params.permit(:pack_id)
    end

    def own_update_params
      params.permit(:player_id, :pack_id)
    end

    def allow_edit
      return unless @current_player.id != @own_pack.player_id

      render status: :unauthorized, json: {
        message: "This item doesn't belong to player #{@current_player.id}"
      }
    end

    def find_own_pack
      @own_pack = OwnPack.find_by!(id: params[:id])
    rescue ::ActiveRecord::RecordNotFound
      render status: :not_found, json: {
        error: "Own with id #{params[:id]} not found"
      }
    end
  end
end
