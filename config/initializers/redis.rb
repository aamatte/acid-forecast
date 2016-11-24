raise ArgumentError.new("Redis URL not provided. Set up ENV['REDIS_URL'].") unless ENV['REDIS_URL']
Redis.current = Redis.new(url: ENV['REDIS_URL'])
