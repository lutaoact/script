local result = '';
local hostCountKeys = redis.call('keys', 'hostCount:'..ARGV[1]..":*")
for index = 1, #hostCountKeys do
  local hashKey = hostCountKeys[index]
  local hash = redis.call('hgetall', hashKey);
  result = result..hashKey..'##'..table.concat(hash, '**').."\n"
  redis.log(redis.LOG_NOTICE, "index: "..index..", hashKey: "..hashKey)
--  redis.log(redis.LOG_NOTICE, result)
  redis.call('del', hashKey)
end
return result;
