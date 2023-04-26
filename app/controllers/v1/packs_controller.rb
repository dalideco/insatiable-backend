module V1
  # packs controller
  class PacksController < ApplicationController
    include PacksControllerDocs

    before_action :authorize_request, except: %i[create]
    before_action :find_pack, only: %i[show update destroy buy]
    before_action :deduct_price, only: :buy

    # for nested routes
    before_action :verify_same_player, only: %i[mine open]
    before_action :verify_player_owns_pack, only: :open
    before_action :find_player_pack, only: :open

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
      # get packs chances
      chances = {
        'common' => @pack.chance_common_weapon,
        'rare' => @pack.chance_rare_weapon,
        'very_rare' => @pack.chance_very_rare_weapon,
        'epic_weapon' => @pack.chance_epic_weapon,
        'legendary_weapon' => @pack.chance_legendary_weapon
      }

      # pick the rarity to choose
      rarity = CustomRandom.random_with_probability(chances)

      # get random weapon with the chosen rarity
      weapon = Weapon.where(variant: rarity).order('RANDOM()').limit(1).first

      # assign the weapon to the player
      own = Own.new(weapon_id: weapon.as_json['id'], player_id: @current_player.id)
      own.save!

      # remove pack from player's owned
      @own_pack.delete

      # render
      render json: {
        success: true,
        weapon: weapon.as_json
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

    def find_player_pack
      @pack = Pack.find_by!(id: params[:pack_id])
    rescue ActiveRecord::RecordNotFound
      render status: :not_found, json: {
        error: 'Pack not found'
      }
    end
  end
end
