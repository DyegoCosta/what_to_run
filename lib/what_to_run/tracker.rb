require 'sqlite3'
require 'coverage_peeker'
require_relative 'differ'

module WhatToRun
  class Tracker
    DB = SQLite3::Database.open '/tmp/run_log.db'

    class << self
      def start
        DB.execute 'drop table if exists coverage'

        DB.execute <<-SQL
          create table if not exists coverage (
            description varchar,
            log blob
          )
        SQL

        @@before_suite = CoveragePeeker.peek_result
      end

      def track(description, before, after)
        coverage = Marshal.dump \
          Differ.coverage_delta(before, after, @@before_suite)

        DB.execute 'insert into coverage VALUES(?, ?)',
          [description, SQLite3::Blob.new(coverage)]
      end

      def finish
        DB.close
      end

      def read
        rows = DB.execute 'select description, log from coverage'
        rows.each {|row| yield [row[0], Marshal.load(row[1])]}
      end

      def compact(coverage)
        coverage.reject {|_, info| Array(info).compact.empty?}
      end
    end

    private_class_method :compact
  end
end
