require 'rails/generators'
require 'rails/generators/migration'

module Lessonable
  module Generators
    class BusinessGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
        
      argument :actions, :type => :array, :default => [], :banner => "action action"
      
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
    
      def self.next_migration_number(path)
          @migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i.to_s
      end
      
      def create_model_file
        template "business.rb", "app/models/business.rb"
        migration_template "create_business.rb", "db/migrate/create_business.rb"
      end
      
    end  
  end
end
