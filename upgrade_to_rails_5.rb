# ruby ~/code/games/upgrade_to_rails_5.rb
# Update rails version in Gemfile
# bundle update rails
# In the case of conflicts, comment out all gems in Gemfile and add them back slowing doing `bundle update`

def upgrade
  change_models_to_inherit_from_application_record
  add_additional_files
  puts "add `config.active_record.belongs_to_required_by_default = true` to application.rb"


  puts "add `config.action_cable.url = 'ws://<domain>.com/cable'` to <environment>.rb"
  puts "add `config.action_cable.allowed_request_origins = ['http://<domain>.com']` to <environment>.rb"
  puts "add `config.action_cable.mount_path = '/cable'` to application.rb"
  puts "add `config.assets.quiet = true` to application.rb"
  puts "add `Websockets\nmount ActionCable.server => '/cable'` to routes.rb"
end

def change_models_to_inherit_from_application_record
  Dir["app/models/*.rb"].each do |filename|
    updated_text = File.read(filename).gsub(" < ActiveRecord::Base", " < ApplicationRecord")
    File.open(filename, "w") do |f|
      f.write(updated_text)
    end
  end
end

def add_additional_files
  action_cable = "// Action Cable provides the framework to deal with WebSockets in Rails.\n// You can generate new channels where WebSocket features live using the rails generate channel command.\n//\n//= require action_cable\n//= require_self\n//= require_tree ./channels\n\n(function() {\n\n  this.App || (this.App = {});\n\n  App.cable = ActionCable.createConsumer();\n\n}).call(this);"
  `mkdir -p app/assets/javascripts`
  `echo "#{action_cable}" > app/assets/javascripts/cable.js`
  app_record = "class ApplicationRecord < ActiveRecord::Base\n  self.abstract_class = true\nend"
  `mkdir -p app/models`
  `echo "#{app_record}" > app/models/application_record.rb`
  action_channel = "module ApplicationCable\n  class Channel < ActionCable::Channel::Base\n  end\nend"
  `mkdir -p app/channels/application_cable`
  `echo "#{action_channel}" > app/channels/application_cable/channel.rb`
  action_connection = "module ApplicationCable\n  class Connection < ActionCable::Connection::Base\n  end\nend"
  `mkdir -p app/channels/application_cable`
  `echo "#{action_connection}" > app/channels/application_cable/connection.rb`
  active_job = "class ApplicationJob < ActiveJob::Base\nend"
  `mkdir -p app/jobs`
  `echo "#{active_job}" > app/jobs/application_job.rb`
  cable_yml = "development:\n  adapter: async\ntest:\n  adapter: async\nproduction:\n  adapter: redis\n  url: redis://localhost:6379/1"
  `echo "#{cable_yml}" > config/cable.yml`
  `mkdir -p app/assets/javascripts/channels`
  `touch app/assets/javascripts/channels/.keep`
end

upgrade




# Websockets!!
        # location / {
        #         sendfile        on;
        #         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        #         proxy_set_header Host $http_host;
        #         proxy_redirect off;
        #         proxy_pass http://localhost:7545;
        #         proxy_set_header X-Real-IP $remote_addr;
        #         proxy_set_header X-Forwarded-Proto http;
        #         proxy_set_header Upgrade $http_upgrade;
        #         proxy_set_header Connection "Upgrade";
        # }
