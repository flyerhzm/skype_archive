require 'rspec'
require 'skype_archive'
require 'support/sqlite_seed'

DB = Sequel.sqlite

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.before(:suite) do
    Support::SqliteSeed.setup_db
    Support::SqliteSeed.seed_db
  end

  config.after(:suite) do
    Support::SqliteSeed.teardown_db
  end
end
