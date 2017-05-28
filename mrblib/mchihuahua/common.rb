# coding: utf-8
module Mchihuahua
  module Helper
    def self.create_project_root_dir
      puts 'Create Project Root Directory.(default: monitors)'
      Dir.mkdir('./monitors') unless Dir.exist?('./monitors')
      puts 'done.'
    end

    def self.filter_monitor(monitor)
      filter = %w[tags query type message id name options]
      monitor.select { |key, _| filter.include? key }
    end

    def self.get_filter(project)
      YAML.load(File.open('./monitors/' + project + '/.filter.yml', 'r').read)
    end

    def self.yaml_file_writer(file_path, data)
      File.open(file_path, "w") do |f|
        yaml_line = YAML.dump(data)
        yaml_line.oreno_unicode_decode
        f.puts(yaml_line)
      end
    end
  end
end
