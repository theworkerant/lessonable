require 'rails/generators'
require 'rails/generators/migration'

module Lessonable
  module Generators
    class LessonsGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
        
      argument :actions, :type => :array, :default => [], :banner => "action action"
      
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
    
      def self.next_migration_number(path)
          @migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S%L").to_i.to_s
      end
      
      def create_lessons
        template "lesson.rb", "app/models/lesson.rb"
        migration_template "create_lessons.rb", "db/migrate/create_lessons.rb"
      end
      
    end  
  end
end
