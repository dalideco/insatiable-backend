class PlayersController < ApplicationController

    rescue_from ::ActiveRecord::RecordNotUnique, with: :existing_email

    def index
        render json: Player.all
    end

    def create
        puts "test"
        puts player_params
        @player = Player.create(player_params)
        

        render json: @player 

    end

    def update
        player = Player.find(params[:id])
        player.update_attributes(player_params)
        render json: player
    end
      
    
    private 
    
    def player_params
        params.require(:email)
        params.require(:password)
        params.require(:player).permit(:email, :password)

    end

    def existing_email(exception)
        render status: 409, json: {"error"=> "Email already exists", "message" => exception.message}
        return
    end
end
