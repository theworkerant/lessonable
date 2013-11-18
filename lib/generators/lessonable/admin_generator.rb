require 'rails/generators'
require 'rails/generators/migration'

module Lessonable
  module Generators
    class AdminGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
        
      argument :actions, :type => :array, :default => [], :banner => "action action"
      
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
    
      def self.next_migration_number(path)
          @migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S%L").to_i.to_s
      end
      
      def create_config
        template "active_admin_initializer.rb", "config/initializers/active_admin.rb"
      end
      def create_comments
        migration_template "create_active_admin_comments.rb", "db/migrate/create_active_admin_comments.rb"
      end
      def admin_example
        template "admin_example_model.rb", "app/admin/example_model.rb"
      end
      
    end  
  end
end
