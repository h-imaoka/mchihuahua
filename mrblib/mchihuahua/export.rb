# coding: utf-8
module Mchihuahua
  class Export < Client
    def initialize(project, *args)
      @dog = Mchihuahua::Client.new.dog
      @project = project
      @args = args.last
      @project_dir = './monitors/' + @project
      @monitors_file_path = @project_dir + '/monitors.yml'
      @filter_file_path = @project_dir + '/.filter.yml'
    end

    def export_result_display(id, name, silenced)
      label = %Q{#{id} | #{name}}
      if silenced == {}
        puts label.set_color(:light_cyan) + ' を書き出しました.'
      else
        puts label.set_color(:red) + ' を書き出しました.'
      end
    end

    def export_monitors(call_from = nil)
      if FileTest.exist?(@filter_file_path) && @args == nil then
        filter = Mchihuahua::Helper.get_filter(@project)
        name = filter['name']
        tags = filter['tags']
      else
        if FileTest.exist?(@filter_file_path) && @args['name'] == nil && @args['tags'] == nil then
          filter = Mchihuahua::Helper.get_filter(@project)
          name = filter['name']
          tags = filter['tags']
        else
          name = @args['name']
          tags = @args['tags']
        end
      end

      filterd_monitors = []
      begin
        @dog.get_all_monitors({:name => name, :tags => tags}).last.each do |monitor|
          export_result_display(monitor['id'], monitor['name'], monitor['options']['silenced']) unless call_from
          filterd_monitors << Mchihuahua::Helper.filter_monitor(monitor)
        end
      rescue => e
        puts e
      end
      return filterd_monitors
    end

    def store_monitors_data(monitors_data)
      Dir.mkdir(@project_dir) unless Dir.exist?(@project_dir)

      unless FileTest.exist?(@filter_file_path) and @args == nil or \
        FileTest.exist?(@filter_file_path) && @args['name'] == nil && @args['tags'] == nil then
        filter = {}
        filter['name'] = @args['name']
        filter['tags'] = @args['tags']
        begin
          File.open(@filter_file_path, "w") {|f| f.write YAML.dump(filter)}
        rescue => e
          puts e
        end
      end

      begin
        File.open(@monitors_file_path, "w") do |f|
          f.puts(YAML.dump(monitors_data).oreno_unicode_decode)
        end
      rescue => e
        puts e
      end
    end
  end
end
