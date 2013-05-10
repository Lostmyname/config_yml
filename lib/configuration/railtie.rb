module Configuration
  class Railtie < Rails::Railtie
    rake_tasks do
      load "configuration/tasks.rb"
    end
  end
end
