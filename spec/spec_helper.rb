require "coveralls"
require "simplecov"
Coveralls.wear!
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start "rails" do
  add_filter "app/admin/"
end

ENV["RAILS_ENV"] ||= "test"
ENV["HIT_STRIPE"] ||= "false"

require File.expand_path("../dummy/config/environment", __FILE__)

require "rspec/rails"
require "rspec/autorun"
require "factory_girl"
require "database_cleaner"
require "json_spec"

require "capybara-webkit"
require "capybara/rspec"
Capybara.javascript_driver  = :webkit
Capybara.default_selector   = :css
Capybara.ignore_hidden_elements = false

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("../support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include FactoryGirl::Syntax::Methods
  config.include JsonSpec::Helpers
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # If you"re not using ActiveRecord, or you"d prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end


DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean # cleanup of the test

RSpec.configure do |config|
  config.around(:each) do |example|
    FactoryGirl.reload
    Capybara.current_driver = :webkit
    example.run
    DatabaseCleaner.clean # cleanup of the test
  end  
end