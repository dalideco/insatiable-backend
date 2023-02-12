ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  set_fixture_class weapons: V1::Weapon
  set_fixture_class packs: V1::Pack
  set_fixture_class owns: V1::Own
  set_fixture_class own_packs: V1::OwnPack
  set_fixture_class offers: V1::Offer
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
