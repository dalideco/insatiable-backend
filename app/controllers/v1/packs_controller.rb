module V1
  # packs controller
  class PacksController < ApplicationController
    include PacksControllerDocs

    before_action :authorize_request, except: %i[create]
    before_action :find_pack, except: %i[create index]

    def index
      render json: Pack.all
    end

    def create
      @pack = Pack.new(pack_params)
      if @pack.save
        render json: @pack
      else
        render status: :bad_request, json: { 'messages' => @player.errors.messages }
      end
    end

    def show
      render json: @pack
    end

    def update
      @pack.update(pack_params)
      render json: @pack
    end

    def destroy
      @pack.delete
      render json: {
        count: 1
      }
    end

    # TODO: create this method
    def buy; end

    private

    def pack_params
      params.permit(:price)
    end

    def find_pack
      @pack = Pack.find_by!(id: params[:id])
    rescue ActiveRecord::RecordNotFound
      render status: :not_found, json: {
        error: 'Pack not found'
      }
    end
  end
end
