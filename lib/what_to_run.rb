require 'set'
require 'rugged'

require_relative 'what_to_run/tracker'

module WhatToRun
  autoload :CLI, 'what_to_run/cli'
  autoload :VERSION, 'what_to_run/version'

  class << self
    def predict
      lines_to_run.inject(Set.new) do |tests, (file, line)|
        tests += Array cov_map[file][line]
      end
    end

    def lines_to_run
      repository = Rugged::Repository.discover('.')
      repository_root = File.expand_path("..", repository.path)
      lines_to_run = Set.new

      repository.index.diff.each_patch do |patch|
        file = patch.delta.old_file[:path]
        file_path = File.join(repository_root, file)

        patch.each_hunk do |hunk|
          hunk.each_line do |line|
            case line.line_origin
            when :addition
              lines_to_run << [file_path, line.new_lineno]
            when :deletion
              lines_to_run << [file_path, line.old_lineno]
            when :context
              # do nothing
            end
          end
        end
      end

      lines_to_run
    end

    def cov_map
      schema = Hash.new { |h, file| h[file] = Hash.new { |i, line| i[line] = [] } }

      @cov_map ||= Tracker.read.inject(schema) do |cov_map, (desc, cov_delta)|
        cov_delta.each_pair do |file, lines|
          file_map = cov_map[file]

          lines.each_with_index do |line, i|
            file_map[i + 1] << desc if line_executed?(line)
          end
        end

        cov_map
      end
    end

    def line_executed?(line)
      line.to_i > 0
    end
  end
end
