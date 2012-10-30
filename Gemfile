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

# Misc.
gem "rake",                               :require => nil
gem "highline",             "~> 1.6.13",  :require => "highline/import"

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

end