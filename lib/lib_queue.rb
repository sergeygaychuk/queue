require "rubygems"
require "bundler/setup"

Bundler.require


require "queue/task"
require "queue/memory_ordered_array"
require "queue/redis_ordered_set"
require "queue/task_serializer"
require "queue/queue"
