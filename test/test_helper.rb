ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    set_fixture_class weapons: V1::Weapon
    set_fixture_class packs: V1::Pack
    set_fixture_class owns: V1::Own
    set_fixture_class own_packs: V1::OwnPack
    set_fixture_class offers: V1::Offer
    set_fixture_class players: V1::Player
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    setup do
      @player = players(:one)
      @player.save
      @player_token = JsonWebToken.encode(player_id: @player.id)
      @player_password = 'test'

      @second_player = players(:two)
      @second_player_token = JsonWebToken.encode(player_id: @second_player.id)
    end

    def authenticate
      @request.headers['AUTHORIZATION'] = "Bearer #{@player_token}"
    end
  end
end
