require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  include V1

  # adding tests
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
    player = Player.new(email: 'test@test.test', password: 'test', password_confirmation: 'test')
    assert player.save
    player1 = Player.new(email: 'test@test.test', password: 'testing', password_confirmation: 'testing')
    assert_not player1.save
  end
end
