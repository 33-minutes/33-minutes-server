require_relative 'config/application'

Rails.application.load_tasks

require 'rubocop/rake_task'
RuboCop::RakeTask.new

task default: %i[rubocop spec]

require 'graphql/rake_task'
GraphQL::RakeTask.new(schema_name: 'Schema')
