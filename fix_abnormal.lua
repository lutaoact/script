local result = {};

local sourceTypes = {1, 2, 3, 4, 11}
--local sourceTypes = {2}

for i = 1, #sourceTypes do
  local pattern = 'abnormal:*:'..sourceTypes[i]
  redis.log(redis.LOG_NOTICE, "pattern: "..pattern)

  local keys = redis.call('keys', pattern)
  for j = 1, #keys do
    local key = keys[j]
    local abnormals = redis.call('lrange', key, 0, -1)
    for k = 1, #abnormals do
      local obj = cjson.decode(abnormals[k]);
      if type(obj.author) ~= 'string' then
        table.insert(result, key..'#'..(k - 1)..'#'..abnormals[k])
        obj.author = ''
        abnormals[k] = cjson.encode(obj);
        redis.log(redis.LOG_NOTICE, key, abnormals[k], type(obj.author))
        redis.call('lset', key, k - 1, abnormals[k])
      end
    end
  end
end

return result;
