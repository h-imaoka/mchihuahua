# mchihuahua

![mchihuahua](https://raw.githubusercontent.com/inokappa/chihuahua/master/images/chihuahua.png)

mchihuahua は [Datadog monitors](http://docs.datadoghq.com/guides/monitoring/) を管理するツールです.

## Caution

* Datadog monitors を YAML DSL で管理してみる試みです
* Monitor Name や Monitor Tags で絞り込んで任意の Monitor のみ抽出して管理出来る筈です
* 基本的には [codenize-tools/barkdog](https://github.com/codenize-tools/barkdog) や [Terraform Datadog Provider](https://www.terraform.io/docs/providers/datadog/) を使いましょう

## Installation

### For MacOS X

1. [こちら](https://github.com/inokappa/mchihuahua/releases/download/v0.0.1/x86_64-apple-darwin14.tar.gz)からダウンロードする
1. ダウンロードしたファイルを解凍する
1. 解凍したファイルをパスが通ったディレクトリに置く

### For Linux

1. [こちら](https://github.com/inokappa/mchihuahua/releases/download/v0.0.1/x86_64-pc-linux-gnu.tar.gz)からダウンロードする
1. ダウンロードしたファイルを解凍する
1. 解凍したファイルをパスが通ったディレクトリに置く

## Usage

```sh
export DATADOG_API_KEY=...
export DATADOG_APP_KEY=...

mchihuahua init
mchihuahua export --project=your_project_name --tags=project:foo,stage:production --dry_run
mchihuahua export --project=your_project_name --tags=project:foo,stage:production
vi ./monitors/your_project_name/monitors.yml
mchihuahua apply --project=your_project_name --dry_run
mchihuahua apply --project=your_project_name
mchihuahua mute --project=your_project_name --monitor_ids=1234567,1234568 --dry_run
mchihuahua mute --project=your_project_name --monitor_ids=1234567,1234568
mchihuahua unmute --project=your_project_name --monitor_ids=1234567,1234568 --dry_run
mchihuahua unmute --project=your_project_name --monitor_ids=1234567,1234568
```

## Help

```
bash-3.2$ mchihuahua --help
Mchihuahua - Datadog monitors management tool
commands:
    apply   - Monitor 設定を apply する.
    export  - Monitor 設定を export する.
    init    - Project の Root ディレクトリ(./monitors)を作成する.
    mute    - Project の監視対象の通知を mute する.
    unmute  - Project の監視対象の通知を unmute する.
    version - show version
Invoke `Mchihuahua COMMAND -h' for details.
```

## mchihuahua example

### export 書き出し

```sh
#
# 初回の書き出し
#
$ mchihuahua export --project=foo --tags=host:vagrant-ubuntu-trusty-64
```

### apply 新規作成

- YAML 定義を ./monitors/your_project_name/monitors.yml に追記

```yaml
- query: avg(last_1m):avg:system.load.5{host:vagrant-ubuntu-trusty-64} > 1
  message: |-
    CPU load is very high on {{host.name}}
    @slack-datadog-notification
  name: Test 5 [{{#is_alert}}CRITICAL{{/is_alert}}{{#is_warning}}WARNING{{/is_warning}}]
    CPU load is very high on {{host.name}}
  type: metric alert
  options:
    thresholds:
      critical: 1.0
      warning: 0.8
```

詳細は http://docs.datadoghq.com/ja/api/?lang=ruby#monitor-create を御確認ください.

- dry-run

```sh
$ mchihuahua apply --project=foo --dry_run

```

- apply

```sh
$ mchihuahua apply --project=foo --dry_run
```

### apply 更新

- thresholds を追記

```yaml
- tags: []
  query: avg(last_1m):avg:system.load.5{host:vagrant-ubuntu-trusty-64} > 1
  message: |-
    CPU load is very high on {{host.name}}
    @slack-datadog-notification
  id: 12345678
  name: Test3 [{{#is_alert}}CRITICAL{{/is_alert}}{{#is_warning}}WARNING{{/is_warning}}]
    CPU load is very high on {{host.name}}
  type: metric alert
  options:
    notify_audit: false
    locked: false
    silenced: {}
    new_host_delay: 300
    require_full_window: true
    notify_no_data: false
    thresholds:
      critical: 1.0
      warning: 0.8
```

詳細は http://docs.datadoghq.com/ja/api/?lang=ruby#monitor-edit を御確認ください.

- dry_run

```sh
$ mchihuahua apply --project=foo --dry_run
```

- apply

```sh
$ mchihuahua apply --project=foo
```

### mute 通知停止

- dry_run

```sh
$ mchihuahua mute --project=your_project_name --monitor_ids=1234567,1234568 --dry_run
```

- apply

```sh
$ mchihuahua mute --project=your_project_name --monitor_ids=1234567,1234568
```

### unmute 通知停止の解除

- dry_run

```sh
$ mchihuahua unmute --project=your_project_name --monitor_ids=1234567,1234568 --dry_run
```

- apply

```sh
$ mchihuahua unmute --project=your_project_name --monitor_ids=1234567,1234568
```
