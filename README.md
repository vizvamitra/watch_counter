# WatchCounter

This gem is my solution for the test task given to me during job placement. Full text of the task (in russian) can be found [here](wiki/task-definition).

WatchCounter is a microservice that can help you to count active watches of your videos. It was developed to do three things:

- To register active watches.
- To answer to "How many videos this customer watches now?"
- To answer to "How many customers are currently watching this video?"

Service will store information about watches only for a short period of time (6 seconds by default), so you will need to continuously send messages to this service to indicate that video is still being watched.

## Table of contents

- [Installation](#installation)
- [How to start a server](#how-to-start-a-server)
- [Usage](#usage)
- [API](#api)
  - [POST /watches](#post-watches)
  - [GET /customers/:id](#get-customers-id)
  - [GET /videos/:id](#get-videos-id)
- [Available storages](#available-storages)
- [TODOS](#todos)
- [Contributing](#contributing)
- [Contacts](#contacts)

## Installation

    git clone git@github.com:vizvamitra/watch_counter.git
    cd watch_counter
    gem build watch_counter.gemspec
    gem install watch_counter-0.1.0.gem

## How to start a server

    RACK_ENV=production watch_counter

## Usage

    Usage: watch_counter [options]

    Available options:
        -b, --bind HOSTNAME              Server hostname or IP address
                                           Default: localhost)
        -p, --port PORT                  Server port
                                           Default: 4567
        -s, --storage STORAGE            Storage
                                           Available: sqlite, memory
                                           Default: sqlite
        -t, --stale-interval SECONDS     Interval of time to remember watches
                                           Default: 6

    Storage-specific options:
        -d, --database PATH              Location of SQLite database
                                           For sqlite storage only
                                           Default: :memory:
        -h, --help                       Show this message
        -v, --version                    Show gem version

## API

Web API has 3 endpoints:

#### POST /watches

A place to send watch events.

###### Arguments

|    Argument |       Example | Required |
| ----------- | ------------- | -------- |
| customer_id | 5, customer_6 | Required |
|    video_id |   3, video_15 | Required |

**customer_id** and **video_id** may be either integers or strings.

###### Responce

Status 204

###### Errors

Incorrect arguments: status 422


#### GET /customers/:id

Returns active watches count for given customer.

###### Responce

    {
      "watches": 15
    }


#### GET /videos/:id

Returns active watches count for given video.

###### Responce

    {
      "watches": 15
    }


## Available storages

Currently service knows how to work only with **SQLite** database and internal **in-memory storage**. You probably don't want to use either of them in production, so you can write your own storage adapter to any DB of your choice. Description of required storage adapter interface can be found [here](blob/master/spec/support/adapters_shared.rb), implementation is up to you.

## TODOS

- Add aditional storage adapters, to Redis for example
- Add security mechanism
- Write RDoc comments for al classes
- Add statistics


## Contributing

1. Fork it ( https://github.com/[my-github-username]/watch_counter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contacts

You can contact me via email: <vizvamitra@gmail.com>. Feel free to make pull requests or create issues)

Dmitrii Krasnov