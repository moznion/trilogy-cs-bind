# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create

require "standard/rake"

task default: %i[test standard]

namespace :rbs do
  task gen: %i[] do
    sh "rbs-inline --output --opt-out lib"
  end
end
