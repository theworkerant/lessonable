require 'rails/generators'
require 'rails/generators/migration'

module Lessonable
  module Generators
    class SchedulesGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
        
      argument :actions, :type => :array, :default => [], :banner => "action action"
      
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
    
      def self.next_migration_number(path)
          @migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S%L").to_i.to_s
      end
      
      def create_schedules
        template "schedule.rb", "app/models/schedule.rb"
        migration_template "create_schedules.rb", "db/migrate/create_schedules.rb"
      end
      
      def schedulables
        migration_template "create_schedulables.rb", "db/migrate/create_schedulables.rb"
      end
      
    end  
  end
end
