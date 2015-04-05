require 'json'
require 'rugged'
require 'set'

require_relative 'what_to_run/tracker'

module WhatToRun
  extend self

  def predict
    lines_to_run.inject([]) do |tests, (file, line)|
      path = File.expand_path(file)
      tests += Array cov_map[path][line]
    end
  end

  def lines_to_run
    repo = Rugged::Repository.discover('.')
    lines_to_run = Set.new

    repo.index.diff.each_patch do |patch|
      file = patch.delta.old_file[:path]

      patch.each_hunk do |hunk|
        hunk.each_line do |line|
          case line.line_origin
          when :addition
            lines_to_run << [file, line.new_lineno]
          when :deletion
            lines_to_run << [file, line.old_lineno]
          when :context
            # do nothing
          end
        end
      end
    end

    lines_to_run
  end

  def cov_map
    return @cov_map if @cov_map

    @cov_map = Hash.new { |h, file| h[file] = Hash.new { |i, line| i[line] = [] } }

    Tracker.read do |desc, cov_delta|
      cov_delta.each_pair do |file, lines|
        file_map = @cov_map[file]

        lines.each_with_index do |line, i|
          file_map[i + 1] << desc if line_executed?(line)
        end
      end
    end

    @cov_map
  end

  def line_executed?(line)
    line.to_i > 0
  end
end
