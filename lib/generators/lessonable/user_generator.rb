require 'rails/generators'
require 'rails/generators/migration'

module Lessonable
  module Generators
    class UserGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
        
      argument :actions, :type => :array, :default => [], :banner => "action action"
      
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
    
      def self.next_migration_number(path)
        sleep(1.0/100.0)
        Time.now.utc.strftime("%Y%m%d%H%M%S%L").to_i.to_s
      end
      
      def install_devise
        invoke "devise:install"
      end
      
      def create_model
        template "user.rb", "app/models/user.rb"
        migration_template "devise_create_users.rb", "db/migrate/devise_create_users.rb"
      end
      
      def create_business_association
        migration_template "add_business_to_users.rb", "db/migrate/add_business_to_users.rb"
      end
      
      def create_user_roles
        migration_template "add_role_to_users.rb", "db/migrate/add_role_to_users.rb"
      end
      
      def create_inheritable_roles
        template "role.rb", "app/models/role.rb"
        migration_template "create_roles.rb", "db/migrate/create_roles.rb"
      end
      
      def create_permissions
        template "permission.rb", "app/models/permission.rb"
        migration_template "create_permissions.rb", "db/migrate/create_permissions.rb"
      end
      
    end  
  end
end
