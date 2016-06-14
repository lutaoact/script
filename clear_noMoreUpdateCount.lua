local hostCountKeys = redis.call('keys', '*noMoreUpdateCount')
for index = 1, #hostCountKeys do
  local hashKey = hostCountKeys[index]
  redis.log(redis.LOG_NOTICE, "index: "..index..", hashKey: "..hashKey)
  redis.call('del', hashKey)
end
return hostCountKeys
