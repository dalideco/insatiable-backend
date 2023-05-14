module ApplicationCable
  # Global connection class
  class Connection < ActionCable::Connection::Base
    identified_by :current_player

    def connect
      current_player = find_current_player
      self.current_player = current_player

      Rails.logger.info "Cable: player #{current_player.id} connected"
    end

    private

    def find_current_player
      # get token from header
      header = request.headers['Authorization']
      header = header.split(' ').last if header

      begin
        @decoded = JsonWebToken.decode(header)
        @current_player = V1::Player.find_by(id: @decoded[:player_id])
      rescue ActiveRecord::RecordNotFound
        Rails.logger.info "Cable: failed to find player #{@decoded[:player_id]}"
        reject_unauthorized_connection
      rescue JWT::DecodeError
        Rails.logger.info 'Cable: failed to decode authorization token'
        reject_unauthorized_connection
      end
    end
  end
end
