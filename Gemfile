source :rubygems

# Sinatra
gem "sinatra",              "1.3.2",        :require => "sinatra/base"
gem "sinatra-flash",        "0.3.0",        :require => "sinatra/flash"
gem "sinatra-support",      "1.2.2",        :require => "sinatra/support"
gem "sinatra-contrib",      "~> 1.3.1"

# Sass/Compass
gem "sass",                 "~> 3.2.1"
gem "compass",              "~> 0.12.2"
gem "formula-framework",    :git => "git://github.com/patrickarlt/formula-framework.git", :require => "formula"

# Templating
gem "erubis",               "2.7.0"

# Conversion
gem "hashie",               "1.2.0"
gem "json"

# Redis/Resque
gem "redis",                "~> 3.0.0"
gem "resque",               "~> 1.22.0"
gem "resque-scheduler",     "~> 2.0.0"
gem "foreman",              "~> 0.57.0"

# Mongoid
gem "mongoid",              "~> 3.0.4"
gem "mongoid-pagination"
gem "mongoid_search",       "~> 0.3.0"
gem "mongoid_slug",         "~> 1.0.1"
gem "mongoid-tree",         "~> 1.0.0"

# Misc.
gem "rake",                               :require => nil
gem "highline",             "~> 1.6.13",  :require => "highline/import"

# File Uploads
#gem "carrierwave", "~> 0.7.0"

# Email
gem "pony",                 "~> 1.4"

# Authentication
gem "omniauth"    
gem "omniauth-twitter",     "~> 0.0.12"
gem "omniauth-facebook",    "~> 1.4.1"
gem "bcrypt-ruby",          :require => "bcrypt"

# Sprockets
gem 'sprockets'
gem 'sprockets-sass'
gem 'sprockets-helpers'

group :development do
  gem "shotgun"
  gem "pry"
  gem "pry-nav"
  gem "heroku"
end

group :test do
  gem "minitest"
  gem "rack-test",          :require => "rack/test"
  gem "webmock"      
  gem "simplecov",          :require => nil
end

group :production do
  gem 'rpm_contrib'
  gem 'newrelic_rpm'
end