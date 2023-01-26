class PlayersController < ApplicationController
    
    def index
        render json: Player.all
    end

    def create
        player = Player.create(player_params)
        render json: player
    end

    def update
        player = Player.find(params[:id])
        player.update_attributes(player_params)
        render json: player
    end
      
    
    private 
    
    def player_params
        params.require(:player).permit(:email, :password)
    end
      
end
