def __main__(argv)
  argv.shift
  case argv[0]
  when "version"
    puts "Mchihuahua: v#{Mchihuahua::VERSION}"
  when "apply"
    Mchihuahua::Cli.apply(argv)
  when "export"
    Mchihuahua::Cli.export(argv)
  when "init"
    Mchihuahua::Cli.init(argv)
  when "mute"
    Mchihuahua::Cli.mute(argv)
  when "unmute"
    Mchihuahua::Cli.unmute(argv)
  else
    puts <<-USAGE
Mchihuahua - Datadog monitors management tool
commands:
    apply   - Monitor 設定を apply する.
    export  - Monitor 設定を export する.
    init    - Project の Root ディレクトリ(./monitors)を作成する.
    mute    - Project の監視対象の通知を mute する.
    unmute  - Project の監視対象の通知を unmute する.
    version - show version
Invoke `Mchihuahua COMMAND -h' for details.
    USAGE
  end
end
