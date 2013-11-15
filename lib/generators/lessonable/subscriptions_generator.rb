require 'rails/generators'
require 'rails/generators/migration'

module Lessonable
  module Generators
    class SubscriptionsGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
        
      argument :actions, :type => :array, :default => [], :banner => "action action"
      
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
    
      def self.next_migration_number(path)
        @migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S%L").to_i.to_s
      end
      
      def create_model_file
        template "subscribable_initializer.rb", "config/initializers/subscribable.rb"
        migration_template "create_subscriptions.rb", "db/migrate/create_subscriptions.rb"
        migration_template "add_subscriptions_to_users.rb", "db/migrate/add_subscriptions_to_users.rb"
      end
      
    end  
  end
end
