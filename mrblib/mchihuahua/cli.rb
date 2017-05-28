module Mchihuahua
  module Cli
    def self.apply_help
        puts <<-HELP
Usage:
  mchihuahua apply

Options:
  --project=PROJECT          # Project を指定.
  --dry_run                  # apply 前の試行.

Monitors 定義を apply する
HELP
    end

    def self.apply(args)
      class << args; include Getopts; end
      opts = args.getopts(
        'h',
        'help',
        'project:',
        'dry_run',
      )
      if opts['h'] || opts['help']
        apply_help
      elsif opts['project']
        dog = Mchihuahua::Update.new(opts['project'])
        dog.update_monitors(opts['dry_run'])
        puts '処理が終了しました.'.set_color(:green)
      end
    end

    def self.export_help
        puts <<-HELP
Usage:
  mchihuahua export

Options:
  --project=PROJECT           # Project を指定.(Project 名でディレクトリを作成する)
  --name=NAME                 # Monitor を name キーで絞り込む.
  --tags=TAG                  # Monitor を tags キーで絞り込む.
  --dry-run                   # export 前の試行.

Monitors 定義を export する
HELP
    end

    def self.export(args)
      class << args; include Getopts; end
      opts = args.getopts(
        'h',
        'help',
        'project:',
        'name:',
        'tags:',
        'dry_run',
      )
      if opts['h'] || opts['help']
        export_help
      elsif opts['project']
        args = {}
        args['name'] = opts['name']
        args['tags'] = opts['tags']
        dog = Mchihuahua::Export.new(opts['project'], args)
        puts 'Monitor 定義を書き出します.(monitor_id | monitor_name)'.set_color(:yellow)
        monitors_data = dog.export_monitors
        dog.store_monitors_data(monitors_data) unless args['dry_run']
        puts monitors_data.length.to_s + ' 件の Monitor 定義を出力しました.'.set_color(:green)
      end
    end

    def self.init(args)
      class << args; include Getopts; end
      opts = args.getopts(
        'h',
        'help'
      )
      if opts['h'] || opts['help']
        puts <<-HELP
Usage:
  mchihuahua init

カレントディレクトリに monitors ディレクトリを作成する.
HELP
      else
        Mchihuahua::Helper.create_project_root_dir
      end
    end

    def self.mute(args)
      class << args; include Getopts; end
      opts = args.getopts(
        'h',
        'help',
        'project:',
        'monitor_ids:',
        'dry_run'
      )
      if opts['h'] || opts['help']
        puts <<-HELP
Usage:
  mchihuahua mute

Options:
  --project=PROJECT           # Project を指定.
  --monitor_ids=MONITOR_IDs   # Monitor ID を指定(カンマ区切りで複数指定可能).
  --dry_run                   # unmute 前の試行.

指定した monitor_id の通知をミュートする.
HELP
      else
        dog = Mchihuahua::Mute.new(opts['project'])
        dog.update_monitors('mute', opts['monitor_ids'], opts['dry_run'])
        puts '処理が終了しました.'.set_color(:green)
      end
    end

    def self.unmute(args)
      class << args; include Getopts; end
      opts = args.getopts(
        'h',
        'help',
        'project:',
        'monitor_ids:',
        'dry_run'
      )
      if opts['h'] || opts['help']
        puts <<-HELP
Usage:
  mchihuahua unmute

Options:
  --project=PROJECT           # Project を指定.
  --monitor_ids=MONITOR_IDs   # Monitor ID を指定(カンマ区切りで複数指定可能).
  --dry_run                   # unmute 前の試行.

指定した monitor_id のミュートを解除する.
HELP
      else
        dog = Mchihuahua::Mute.new(opts['project'])
        dog.update_monitors('unmute', opts['monitor_ids'], opts['dry_run'])
        puts '処理が終了しました.'.set_color(:green)
      end
    end
  end
end
