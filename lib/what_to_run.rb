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
    repo = Rugged::Repository.new('.')
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

  def cov_delta(before, after)
    after.each_with_object({}) do |(file_name, lines_cov), delta|
      before_lines_cov = before[file_name]

      # skip arrays that are exactly the same
      next if before_lines_cov == lines_cov

      # subtract the old coverage from the new coverage
      cov = lines_cov_delta(before_lines_cov, lines_cov)

      # add the "diffed" coverage to the hash
      delta[file_name] = cov
    end
  end

  def cov_map
    cov_map = Hash.new { |h, file| h[file] = Hash.new { |i, line| i[line] = [] } }

    Tracker.read do |cov_info|
      before, after = cov_info.last(2)
      desc = cov_info.first

      delta = cov_delta(before, after)

      delta.each_pair do |file, lines|
        file_map = cov_map[file]

        lines.each_with_index do |val, i|
          file_map[i + 1] << desc if line_executed?(val)
        end
      end
    end

    cov_map
  end

  def line_executed?(line)
    line.to_i > 0
  end

  def lines_cov_delta(before_lines_cov, after_lines_cov)
    after_lines_cov.zip(before_lines_cov).map do |lines_after, lines_before|
      lines_after ? lines_after - lines_before : lines_after
    end
  end
end
