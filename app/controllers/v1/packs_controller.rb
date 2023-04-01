module V1
  # packs controller
  class PacksController < ApplicationController
    include PacksControllerDocs

    before_action :authorize_request, except: %i[create]
    before_action :find_pack, except: %i[create index mine open]
    before_action :deduct_price, only: :buy

    # for nested routes
    before_action :verify_same_player, only: %i[mine open]
    before_action :verify_player_owns_pack, only: :open

    def index
      render json: {
        success: true,
        packs: Pack.all.as_json
      }
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

    # For player to buy a pack
    def buy
      own_pack = OwnPack.new(pack_id: params[:id],
                             player_id: @current_player.id)

      if own_pack.save
        render json: {
          'success' => true,
          'own_pack' => own_pack
        }
      else
        render status: :bad_request, json: {
          'success' => false,
          'errors' => own_pack.errors.messages
        }
      end
    end

    ############# player nested
    def mine
      render json: {
        success: true,
        packs: @current_player.owned_packs
      }
    end

    def open
      render json: {
        test: 'test'
      }
    end

    ########## private
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

    def deduct_price
      price = @pack.price
      balance = @current_player.coins

      return unless balance < price

      render status: :payment_required, json: {
        'success' => false,
        'errors' => 'Insufficient balance of coins'
      }
    end

    def verify_same_player
      return unless @current_player.id != params[:player_id].to_i

      render status: :unauthorized, json: {
        success: false,
        errors: 'Not allowed to view this player\'s packs'
      }
    end

    def verify_player_owns_pack
      @own_pack = OwnPack.find_by!(player_id: params[:player_id].to_i, pack_id: params[:pack_id].to_i)
    rescue ::ActiveRecord::RecordNotFound
      render status: :unauthorized, json: {
        success: false,
        errors: 'Cannot open an not owned pack'
      }
    end
  end
end
