# datadog-sidekiq

Send Sidekiq metrics to Datadog via DogStatsD.

[![GitHub release](https://img.shields.io/github/release/feedforce/datadog-sidekiq.svg?style=flat-square)](https://github.com/feedforce/datadog-sidekiq/releases)
[![MIT license](https://img.shields.io/github/license/feedforce/datadog-sidekiq.svg?style=flat-square)](https://github.com/feedforce/datadog-sidekiq/blob/master/LICENSE)
[![Docker Automated build](https://img.shields.io/docker/cloud/automated/feedforce/datadog-sidekiq.svg?color=blue&style=flat-square)](https://hub.docker.com/r/feedforce/datadog-sidekiq)

## Installation

Grab the latest binary from the GitHub [releases](https://github.com/feedforce/datadog-sidekiq/releases) page.

or run with Docker.

```
$ docker run -it feedforce/datadog-sidekiq
```

## Usage

```
$ datadog-sidekiq
```

In production, recommend using crontab etc. to run every minute.

```
$ crontab -l
* * * * * /usr/local/bin/datadog-sidekiq
```

### Options

| Option | Description | Default value |
| --- | --- | --- |
| `-redis-db` | Redis DB | 0 |
| `-redis-host` | Redis host | 127.0.0.1:6379 |
| `-redis-namespace` | Redis namespace for Sidekiq | |
| `-redis-password` | Redis password | |
| `-statsd-host` | DogStatsD host | 127.0.0.1:8125 |
| `-tags` | Add custom metric tags for Datadog. Specify in \"key:value\" format. Separate by comma to specify multiple tags | |
| `-version` | Show datadog-sidekiq version | false |

## Development

### Requirements

* Docker
* Go `~> 1.9.0`

### Local development

```
$ docker-compose up -d
$ docker-compose logs dogstatsd
Attaching to datadog-sidekiq_dogstatsd_1
dogstatsd_1        | 2019/04/12 02:55:17 listening over UDP at  0.0.0.0:8125
dogstatsd_1        | sidekiq.dead:0.000000|g|#tag1:value1,tag2:value2
dogstatsd_1        | sidekiq.retries:0.000000|g|#tag1:value1,tag2:value2
dogstatsd_1        | sidekiq.schedule:0.000000|g|#tag1:value1,tag2:value2
```

### Release

1. Create and export `$GITHUB_TOKEN` required from [ghr](https://github.com/tcnksm/ghr#github-api-token)
1. Run `$ git checkout master && git pull origin master`
1. Bump version in [main.go](https://github.com/feedforce/datadog-sidekiq/blob/master/main.go#L13)
1. Run `$ git commit -am "Bump version" && git push origin master`
1. Run `$ make release`
