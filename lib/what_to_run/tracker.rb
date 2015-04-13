require 'sqlite3'
require 'fileutils'

require 'coverage_peeker'
require_relative 'differ'

module WhatToRun
  class Tracker
    FileUtils.mkdir_p('.what_to_run')

    DB_NAME = 'run_log'.freeze

    DB = SQLite3::Database.open \
      ".what_to_run/#{DB_NAME}#{ENV['TEST_ENV_NUMBER']}.db"

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

        unless additional_databases.empty?
          attach_databases!
          query += union_query
        end

        DB.execute(query).map { |row| [row[0], Marshal.load(row[1])] }
      end

      def additional_databases
        count = Dir['.what_to_run/*.db'].length
        (2..count).map { |n| "#{DB_NAME}#{n}" }
      end

      def attach_databases!
        additional_databases.each do |db|
          DB.execute "attach '.what_to_run/#{db}.db' as #{db}"
        end
      end

      def union_query
        additional_databases.inject('') do |query, db|
          query += " union select description, log from #{db}.coverage"
        end
      end
    end

    private_class_method :additional_databases,
      :attach_databases!, :union_query
  end
end
