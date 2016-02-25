# WatchCounter

[![Code Climate](https://codeclimate.com/github/vizvamitra/watch_counter/badges/gpa.svg)](https://codeclimate.com/github/vizvamitra/watch_counter)

This gem is my solution for the test task given to me during job placement. Full text of the task (in russian) can be found [here](https://github.com/vizvamitra/watch_counter/wiki/Task-definition).

WatchCounter is a microservice that can help you to count active watches of your videos. It was developed to do three things:

- To register active watches.
- To answer to "How many videos this customer watches now?"
- To answer to "How many customers are currently watching this video?"

Service will store information about watches only for a short period of time (6 seconds by default), so you will need to continuously send messages to this service to indicate that video is still being watched.

Please note that the task demands to use inmemory storage, but suggests to provide an ability to easily replace it an with external storage using adapter pattern.

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
- [Implementation notes](#implementation-notes)
  - [In-memory storage implementation](#in-memory-storage-implementation)
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

|    Argument |      Examples | Required |
| ----------- | ------------- | -------- |
| customer_id | 5, customer_6 | Required |
|    video_id |   3, video_15 | Required |

**customer_id** and **video_id** may be either integers or strings.

###### Responce:

Status 204

###### Errors:

Incorrect arguments: status 422


#### GET /customers/:id

Returns active watches count for given customer.

###### Responce:

    {
      "watches": 15
    }


#### GET /videos/:id

Returns active watches count for given video.

###### Responce:

    {
      "watches": 15
    }


## Available storages

Currently service knows how to work only with **SQLite** database and internal **in-memory storage**. You probably don't want to use either of them in production, so you can write your own storage adapter to any DB of your choice. Description of required storage adapter interface can be found [here](spec/support/adapters_shared.rb), implementation is up to you.

## TODOS

- Add aditional storage adapters, to Redis for example
- Add security mechanism
- Write RDoc comments for al classes
- Add statistics

## Implementation notes

There are two major parts in working service: **storage** and **WatchCounter::HttpServer**. Storage is responsible for data persistance while HttpServer serves API.

**WatchCounter::App** class is a representation of service. It aggregates storage and starts HttpServer. 

**WatchCounter** module initializes and holds the only instance of App and also provides interface to configure service.

Storage mechanism may vary depending on chosen storage adapter. Currently gem supports in-memory storage and SQLite.

#### In-memory storage implementation

Source code for in-memory storage adapter can be found [here](lib/watch_counter/storage/memory.rb), implementation of the in-memory database is [here](lib/watch_counter/storage/memory/database.rb).

Internally data is stored within array where each record is a hash. Format of that hash is `{timestamp: Time, customer_id: String, video_id: String}`. 

According to the task definition, in each moment we want to work only with a small actual subset of records while older ones can be safely removed.

Each new record is added to the end of data array. Furthermore, the timestamp of each new record is greater or equal to the previous one, so **data array is sorted** by timestamp for free, just due to the nature of data. This allows us to use **binary search** to find records by timestamp. But what we realy need is to find an index of a record being a border between aclual and out-of-date records.

Here is the expression to find desired index: `(0..data.size-1).bsearch{|i| data[i][:timestamp] >= timestamp}`. Usage of Ruby's `Range#bsearch` allows us to avoid memory allocation for the whole range while search is log(n)-quick.

When we have the border index we can quickly get actual records. Now to get active watches count for a video/customer we need to count actual records with corresponding video_id/customer_id and database cleanup is as simple as `data = actual_records`.

## Contributing

1. Fork it ( https://github.com/vizvamitra/watch_counter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contacts

You can contact me via email: <vizvamitra@gmail.com>. Feel free to make pull requests or create issues)

Dmitrii Krasnov
