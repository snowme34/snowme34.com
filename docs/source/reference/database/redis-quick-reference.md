# Redis Quick Reference

Content based on:

* [The Little Redis Book by Karl Seguin](https://www.openmymind.net/2012/1/23/The-Little-Redis-Book/)
  * Attribution-NonCommercial 3.0 Unported license
* [Try Redis (unmaintained)](https://github.com/badboy/try.redis)
  * https://try.redis.io/
  * [MIT](https://github.com/badboy/try.redis/blob/master/LICENSE)
  * Copyright (c) 2010 Alex McHale (alexmchale@gmail.com)

## Get Started

```bash
redis-server
redis-cli
redis-benchmark
```

In cli:

```redis
help LLEN
```

Erase all

```redis
flushdb
```

Sorry for mixing uppercase and lowercase

## Basic

```redis
GET
SET
SET server:name "a b c d"
SETNX

DEL

INCR
DECR

EXPIRE server:name 120
TTL server:name // -2 means already expired, -1 means never expire
// set will reset TTL

expireat somekey:1 1356933600 // 12 a.m. 12/31/2012
// seconds since 1/1/1970

// remove EXPIRE
persist server:name

// set a str and specify a time to live in a single atomic command
setex server:name 30 'localhost...'
```

Store JSON

* hash (a data structure of Redis) would be more flexible

```redis
set users:leto '{"name": "leto", "planet": "dune", "likes": ["spice"]}'
```

Bitmap

* https://blog.getspool.com/2011/11/29/fast-easy-realtime-metrics-using-redis-bitmaps/

```redis
setbit
getbit
```

## Data Structures

list

```redis
RPUSH mylist "item1"
RPUSH mylist "item2"
LPUSH mylist "item0"

LLEN mylist

LRANGE mylist 0 -1 // until the end
LRANGE mylist 1 2

LPOP mylist
RPOP mylist

LTRIM mylist 0 49 // only keep 50 elements, if done each time insert, will be O(N=1)
```

set

```redis
SADD myset "0"
SREM myset "0"
SISMEMBER myset "0"
SMEMBERS myset
SUNION myset anotherset

SINTER friends:a friends:b
SINTERSTORE friends:a_b friends:a friends:b
```

sorted sets

* each value has an associated score to sort
* values with same score are sorted "lexicographically"
* [Learn more](https://redis.io/topics/indexes)

```redis
ZADD mysortedset 0 "mystr"
ZADD mysortedset 0 0
ZADD mysortedset 1 1

ZRANGE mysortedset 0 -1

ZCOUNT friends:a 90 100 // # of friends with score between 90 and 100
ZRANK
ZREVRANK friends:a b // rank of b, reversed

zremrangebyscore
```

Hashes

```redis
HSET user:0 name "root"
HSET user:0 email "root@localhost"
HSET user:0 password "ewqjczewq1213wq321"

HGET user:0 name
HGETALL user:0

HKEYS user:0

HMSET user:1000 name "user" email "user@localhost" password "!"

HSET user:1000 attempts 3
HINCRBY user:1000 attempts 1021

HDEL user:1000 attempts
HINCRBY user:1000 attempts 1024
```

## Other Commands

switch database

```redis
select 1
select 0 // default
```

Get help (?)

```redis
help
MEMORY HELP
```

```redis
info
```

## Common Pattern

use hashes to make common queries make sense

```redis
set users:9001 '{"id": 9001, "email": "leto@dune.gov", ...}' 
hset users:lookup:email leto@dune.gov 9001

// either
get users:9001

// or (ruby)
// id = redis.hget( 'users:lookup:email', 'leto@dune.gov')
// user = redis.get("users:#{id}")
```

use set as manual indexes

* maintenance cost and processing and memory cost of extra indexes

```redis
sadd friends:leto ghanima paul chani jessica // indexes of friends
sadd friends_of:chani leto paul // inverse relationships, needed if chani updates
```

## Round Trips and Pipelining

```ruby
ids = redis.lrange('newusers', 0, 9) 
redis.mget(*ids.map {|u| "users:#{u}"})
```

```redis
sadd friends:vladimir piter
sadd friends:paul jessica leto "leto II" chani
```

pipelined

* With pipelining you can send a number of requests without waiting for their responses. This reduces the networking overhead and can result in significant performance gains.
* Redis uses memory to queue up the commands

```ruby
redis.pipelined do
    9001.times do
        redis.incr('powerlevel')
    end
end
```

## Transactions

commands already do multiple things

```redis
incr      // set then get
getset    // sets new but return original
setnx     // check exists and only set if not
```

run multiple commands as an atomic group

* [Transactions – Redis](https://redis.io/topics/transactions)
* The commands will be executed in order
* The commands will be executed as a single atomic operation (without another client’s command being executed halfway through)
* That either all or none of the commands in the transaction will be executed
* Can be combined with pipeline

```redis
multi
hincrby groups:1percent balance -9000000000
hincrby groups:99percent balance 9000000000
exec // execute commands
// exec OR discard
discard // throw away commands
```

Add a watch

* We **cannot** simply get current first then set since other client might change the value and that is not how Redis transaction works

```ruby
redis.multi()
current = redis.get('powerlevel')
redis.set('powerlevel', current + 1)
redis.exec()
```

* If another client changes the value of powerlevel after we’ve called watch on it, our transaction will fail. If no client changes the value, the set will work. We can execute this code in a loop until it works.

```ruby
redis.watch('powerlevel')
current = redis.get('powerlevel')
redis.multi()
redis.set('powerlevel', current + 1)
redis.exec()
```

## Don't use `keys` in production code

Don't

```redis
keys bug:1233:*
```

Do

```redis
hset bugs:1233 1 '{"id":1, "account": 1233, "subject": "..."}'
hset bugs:1233 2 '{"id":2, "account": 1233, "subject": "..."}'
```

## Publication and Subscriptions

(?)

returns and removes the first (or last) element from the list or blocks until one is available

```redis
blpop
brpop
```

```redis
subscribe cute-channel
psubscribe cute-channel:*
publish warnings "it's over 9000!"
// returns the number of clients received the message
```

## Monitor and Log

See commands of other sessions

```redis
monitor
```

show log of commands that takes longer than some microseconds

output format:
• An auto-incrementing id
• A Unix timestamp for when the command happened
• The time, in microseconds, it took to run the command
• The command and its parameters

```redis
config set slowlog-log-slower-than 0
showlog len // number of items
showlog get
showlog get 10 // most recent
```

## Sort

sort 3 (count) elements from position 0 (offset), descending, using alphabet

```redis
sort friends:nobody limit 0 3 desc alpha
```

sort by referenced objects

```redis
// potentially messy way
sadd numbers 1 2 3 4
set values:1 0
set values:2 5
set values:3 3
set values:4 2

sort number by values:* desc

// work on hashes
hset bug:12339 severity 3
hset bug:12339 priority 1
hset bug:12339 details '{"id": 12339, ....}'

hset bug:1382 severity 2
hset bug:1382 priority 2
hset bug:1382 details '{"id": 1382, ....}'

hset bug:338 severity 5
hset bug:338 priority 3
hset bug:338 details '{"id": 338, ....}'

// specify what to retrieve
sort watch:leto by bug:*->priority get bug:*->details
// store
sort watch:leto by bug:*->priority get bug:*->details store watch_by_priority:leto
```

## scan

Instead of `keys`, Redis provides a production-safe command, `scan`

* returns a cursor and a result
* only 0 cursor means no additional results
* may return same item more than once
* [SCAN - Redis](https://redis.io/commands/scan)

```redis
scan
sscan
hscan
zscan
```

## Links

* [Persistence - Redis](https://redis.io/topics/persistence)
* [Commands - Redis](https://redis.io/commands)
* [Data Types - Redis](https://redis.io/topics/data-types)
* [What Redis Data Structures Look Like - Redis Lab](https://redislabs.com/ebook/part-1-getting-started/chapter-1-getting-to-know-redis/1-2-what-redis-data-structures-look-like/)
* [Best Practices - Redis Lab](https://redislabs.com/community/redis-best-practices/)
* [Think in Redis Part One](https://matt.sh/thinking-in-redis-part-one)

Python Redis

* [redis-py’s documentation](https://redis-py.readthedocs.io/en/latest/index.html)
* [Python Redis - Redis Lab](https://redislabs.com/lp/python-redis/)

## Few Words about Python Redis

Redis by default will encode using utf-8 but will not automatically decode for you.

One solution:

```python
r = redis.Redis(
        host='localhost',
        decode_responses=True,
    )
```