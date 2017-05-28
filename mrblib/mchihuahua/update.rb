# coding: utf-8
module Mchihuahua
  class Update < Client

    def initialize(project)
      @dog = Mchihuahua::Client.new.dog
      @exporter = Mchihuahua::Export.new(project)
      @project = project
      @project_dir = './monitors/' + @project
      @monitors_file_path = @project_dir + '/monitors.yml'
      @current_monitor_tmp_file = @project_dir + '/.monitors.yml.current'
      @latest_monitor_tmp_file = @project_dir + '/.monitors.yml.latest'
      @filter_file_path = @project_dir + '/.filter.yml'
    end

    def apply_result_display(res)
      puts 'Monitor Name: ' + "#{res['name']}".set_color(:light_cyan) + ' を更新しました.'
    end

    def update_monitor(data)
      puts 'Monitor ID: ' + "#{data['id']}".set_color(:yellow) + ' を更新します.'
      begin
        res = @dog.update_monitor(data['id'], data['type'], data['query'], :message => data['message'], :name => data['name'], :options => data['options'])
      rescue => e
        puts e
      end
      return res.last unless res.first == 200
      apply_result_display(res.last)
    end

    def create_monitor(data)
      puts 'Monitor Name: ' + "#{data['name']}".set_color(:yellow) + ' を追加します.'
      begin
        res = @dog.monitor(data['type'], data['query'], :message => data['message'], :name => data['name'], :options => data['options'])
      rescue => e
        puts e
      end
      return res.last unless res.first == 200
      apply_result_display(res.last)
    end

    def update_monitors(dry_run)
      filter = Mchihuahua::Helper.get_filter(@project)
      current_monitors = @exporter.export_monitors('call_from_updater')
      datas = YAML.load(File.open(@monitors_file_path, 'r').read)
      apply_flag = []
      datas.each do |data|
        # 新規登録 or 更新のチェック(id キーが有れば更新)
        if data.has_key?('id') then
          Mchihuahua::Helper.yaml_file_writer(@current_monitor_tmp_file,
                                              current_monitors.select {|m| m['id'] == data['id']}.last)
          Mchihuahua::Helper.yaml_file_writer(@latest_monitor_tmp_file, data)
          diff_output, diff_error, diff_code = \
            Open3.capture3("diff", "-u", "#{@current_monitor_tmp_file}", "#{@latest_monitor_tmp_file}")
          # 差分の有無をチェック(diff != "\n" であれば差分が有ると判断)
          if diff_output != "" then
            # --dry-run フラグのチェック
            if dry_run then
              puts '*** 差分を確認して下さい. ***'.set_color(:yellow)
              puts diff_output
              puts ''
            else
              update_monitor(data)
              apply_flag << '1'
            end
          end
        else
          # 新規登録
          # --dry-run フラグのチェック
          if dry_run == nil then
            create_monitor(data)
            apply_flag << '1'
          else
            puts '*** 設定の内容を確認して下さい. ***'.set_color(:yellow)
            puts YAML.dump(data).oreno_unicode_decode.set_color(:light_cyan)
            puts ''
          end
        end
      end
      unless dry_run or apply_flag.empty? then
        monitors_data = @exporter.export_monitors('call_from_updater')
        @exporter.store_monitors_data(monitors_data)
      end
      Open3.capture3("rm", "-f", "#{@current_monitor_tmp_file}") if @current_monitor_tmp_file
      Open3.capture3("rm", "-f", "#{@latest_monitor_tmp_file}") if @latest_monitor_tmp_file
    end

  end
end
