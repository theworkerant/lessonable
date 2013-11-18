require 'rails/generators'
require 'rails/generators/migration'

module Lessonable
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
        
      argument :actions, :type => :array, :default => [], :banner => "action action"
      
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
          
      def create_model_file
        invoke "lessonable:business"
        invoke "devise:install"
        invoke "lessonable:user"
        invoke "lessonable:subscriptions"
      end
      
    end  
  end
end
