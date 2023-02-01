module V1
  # Weapon controller
  class WeaponsController < ApplicationController
    # Authentication required
    before_action :authorize_request
    # Initialyy finding weapon unless it's create or index method
    before_action :find_weapon, except: %i[create index]

    def index
      render json: Weapon.all
    end

    def create
      # Creating an object with stringified stats
      copy = weapon_create_params.dup
      copy[:stats] = JSON.generate(copy[:stats])

      @weapon = Weapon.new(copy)
      if @weapon.save
        render json: @weapon
      else
        render status: :bad_request, json: {
          message: @player.errors.messages
        }
      end
    end

    def show
      render json: @weapon
    end

    def update
      @weapon.udpate(weapon_update_params)
      render json: @weapon
    end

    def delete
      @weapon.delete
      render json: {
        count: 1,
        message: "Delete weapon width id: #{@weapon.id}"
      }
    end

    private

    def weapon_create_params
      params.require(:variant)
      # TODO: @trino set stats for weapon
      params.permit(:image, :variant, stats: %i[damage accuracy])
    end

    def weapon_update_params
      params.permit(:image, :stats, :variant)
    end

    def find_weapon
      @weapon = Weapon.find_by!(id: params[:id])
    rescue ActiveRecord::RecordNotFound
      render status: :not_found, json: {
        error: 'Weapon not found'
      }
    end
  end
end
