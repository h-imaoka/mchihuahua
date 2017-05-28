# coding: utf-8
module Mchihuahua
  class Mute < Client

    def initialize(project)
      @dog = Mchihuahua::Client.new.dog
      @exporter = Mchihuahua::Export.new(project)
      @project = project
      @project_dir = './monitors/' + @project
      @monitors_file_path = @project_dir + '/monitors.yml'
      @filter_file_path = @project_dir + '/.filter.yml'
    end

    def apply_result_display(res)
      puts 'Monitor Name: ' + "#{res['name']}".set_color(:light_cyan) + ' を更新しました.'
    end

    def mute_monitor(monitor_id)
      puts 'Monitor ID: ' + monitor_id.set_color(:yellow) + ' を mute します.'
      begin
        res = @dog.mute_monitor(monitor_id)
      rescue => e
        puts e
      end
      return res.last unless res.first == 200
      apply_result_display(res.last)
    end

    def unmute_monitor(monitor_id)
      puts 'Monitor ID: ' + monitor_id.set_color(:yellow) + ' を unmute します.'
      begin
        res = @dog.unmute_monitor(monitor_id)
      rescue => e
        puts e
      end
      return res.last unless res.first == 200
      apply_result_display(res.last)
    end

    def update_monitors(action, monitor_ids, dry_run = nil)
      apply_flag = []
      monitor_ids.split(',').each do |monitor_id|
        # --dry-run フラグのチェック
        if dry_run then
          puts '*** mute する Monitor ID を確認して下さい. ***'.set_color(:yellow) if action == 'mute'
          puts '*** ummute する Monitor ID を確認して下さい. ***'.set_color(:yellow) if action == 'unmute'
          puts monitor_id
          puts ''
        else
          mute_monitor(monitor_id) if action == 'mute'
          unmute_monitor(monitor_id) if action == 'unmute'
          apply_flag << '1'
        end
      end
      unless dry_run or apply_flag.empty? then
        monitors_data = @exporter.export_monitors('call_from_updater')
        @exporter.store_monitors_data(monitors_data)
      end
    end

  end
end
