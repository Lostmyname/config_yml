require "configuration/tasks/generate"

namespace :config_yml do
  desc "Generate .yml files copying from .yml.sample or .yml.example files."
  task :generate do
    Configuration::Tasks::Generate.generate_ymls
  end
end
