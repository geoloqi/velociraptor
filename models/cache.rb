# Use with Dalli: http://github.com/mperham/dalli
module Dalli
  class Client
    def self.key_name(val)
      "website_#{val.gsub(' ', '-')}"
    end

    alias_method :original_delete, :delete
    def delete(key)
      original_delete self.class.key_name(key)
    end

    def bump_namespace(namespace, ttl)
      version = get(namespace).to_i
      set namespace, version+1, ttl
    end

    def get_fresh(key, ttl=0, namespace=nil, &block)
      if SiteConfig.memcache.enabled.to_s == 'true'
        if namespace
          version = get(namespace).to_i
          key = key+version.to_s
        end
        resp = get self.class.key_name(key)
        return resp if resp
        resp = yield
        set self.class.key_name(key), resp, ttl
        resp
      else
        block.call
      end
    end
  end
end