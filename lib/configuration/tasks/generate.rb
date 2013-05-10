module Configuration
  module Tasks
    module Generate
      class << self
        def generate_ymls
          grouped_files.each do |group, files|
            sample = files.find { |file| file =~ /\.yml\.(s|ex)ample$/ }
            destination = files.find { |file| file =~ /\.yml$/ }

            begin
              case files.count
              when 1
                generate(sample)
              when 2
                replace(sample, destination)
              else
                raise
              end
            rescue
              handle_error(group)
            end
          end
        end

        def grouped_files
          @grouped_files ||= Dir.glob("config/*.yml*").group_by do |file|
            file.match(/((config\/)([^.]*))/i)[3]
          end
        end

        private

        def generate(sample)
          if sample =~ /\.(s|ex)ample$/
            destination = sample.sub(/\.(s|ex)ample/, '')
            FileUtils.cp(sample, destination)
            puts "#{destination} generated from #{sample}"
          end
        end

        def replace(sample, destination)
          if read_content(sample) != read_content(destination)
            FileUtils.cp(sample, destination)
            puts "#{destination} content have been replaced by #{sample} content"
          end
        end

        def read_content(file)
          File.open(file, 'r').readlines
        end

        def handle_error(group)
          puts "An error ocurred when trying to copy config/#{group}.* files."
        end
      end
    end
  end
end
