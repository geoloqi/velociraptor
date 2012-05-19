class Redis
	def self.new_from_yaml(path)
    file = File.read(path)
    erb = ERB.new(file).result
    yaml = YAML.load(erb)[ENV['RACK_ENV']]
    redis_config = URI.parse(yaml['redis_url'])
    redis = Redis.new(host: redis_config.host, port: redis_config.port, password: redis_config.password)
    Redis::Namespace.new(yaml["namespace"], :redis => redis)
	end
end