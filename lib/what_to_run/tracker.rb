require 'sqlite3'
require 'fileutils'

require 'coverage_peeker'
require_relative 'differ'

module WhatToRun
  class Tracker
    FileUtils.mkdir_p('.what_to_run')

    DB = SQLite3::Database.open \
      ".what_to_run/run_log#{ENV['TEST_ENV_NUMBER']}.db"

    class << self
      def start
        DB.execute 'drop table if exists coverage'

        DB.execute <<-SQL
          create table if not exists coverage (
            description varchar,
            log blob
          )
        SQL

        @before_suite = CoveragePeeker.peek_result
      end

      def track(description, before, after)
        coverage = Marshal.dump \
          Differ.coverage_delta(before, after, @before_suite)

        DB.execute 'insert into coverage VALUES(?, ?)',
          [description, SQLite3::Blob.new(coverage)]
      end

      def finish
        DB.close
      end

      def read
        query = 'select description, log from coverage'
        databases_count = Dir['.what_to_run/*.db'].length

        if databases_count > 1
          attach_databases!(databases_count)
          query += union_query(databases_count)
        end

        DB.execute(query).each {|row| yield [row[0], Marshal.load(row[1])]}
      end

      def attach_databases!(count)
        (2..count).each do |n|
          DB.execute "attach '.what_to_run/run_log#{n}.db' as db#{n}"
        end
      end

      def union_query(count)
        (2..count).inject('') do |q, n|
          q += " union select description, log from db#{n}.coverage"
        end
      end
    end

    private_class_method :attach_databases!, :union_query
  end
end
