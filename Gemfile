source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'bcrypt'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'email_validator'
gem 'graphql'
gem 'graphql-errors'
gem 'mongoid'
gem 'puma', '~> 3.11'
gem 'rack-cors'
gem 'rails', '~> 5.2.0'
gem 'warden'

group :development, :test do
  gem 'database_cleaner'
  gem 'fabrication'
  gem 'faker'
  gem 'graphlient'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'timecop'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
