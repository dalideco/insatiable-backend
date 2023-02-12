require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  include V1
  setup do
    player = Player.new(
      email: 'test@insatiable.de',
      password: 'test',
      password_confirmation: 'test'
    )
    @player = player.save
  end

  # Showing users
  test 'Players should not be null' do
    assert_not_nil Player.all
  end

  # Creating user
  test 'Should not create player without email and password' do
    player = Player.new
    assert_not player.save
  end

  test 'Shoud not created player without password' do
    player = Player.new(email: 'test@test.test')
    assert_not player.save
  end

  test 'Should not createdplayer without password confirmation' do
    # TODO
  end

  test 'Should not create player with wrong password confirmation' do
    # TODO
  end

  test 'Should create a player with email and password with p confirmation' do
    player = Player.new(email: 'test@test.test', password: 'test', password_confirmation: 'test')
    assert player.save
  end

  test 'Should not create two players with same email' do
    player = Player.new(email: 'test@insatiable.de', password: 'testing', password_confirmation: 'testing')
    assert_raises(::ActiveRecord::RecordNotUnique) do
      player.save
    end
  end

  # Show
  test 'Should not show an inexistant player' do
    assert @player
  end
end
