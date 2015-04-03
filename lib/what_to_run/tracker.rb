require 'json'

module WhatToRun
  class Tracker
    LOGS = []

    class << self
      def track(description, before, after)
        LOGS << [description, before, after]
      end

      def dump
        File.open('run_log.json', 'w') do |f|
          f.write JSON.dump LOGS
        end

        LOGS.clear
      end

      def read(&block)
        File.open('run_log.json') do |file|
          JSON.parse(file.read).each(&block)
        end
      end
    end
  end
end
