module WhatToRun
  class Differ
    class << self
      ##
      # Gives the delta beteween the coverage result
      # before and after a test run and before starting
      # the test suite
      #
      # Results in the lines that may trigger the test
      # that gave the after result
      def coverage_delta(cov_before, cov_after, cov_before_suite)
        cov_after.each_with_object({}) do |(file_name, lines_cov_after), delta|
          lines_cov_before = cov_before[file_name]
          lines_cov_before_suite = cov_before_suite[file_name]

          next unless file_covered?(lines_cov_before, lines_cov_after)

          lines_delta = lines_cov_delta \
            lines_cov_before_suite, lines_cov_before, lines_cov_after

          delta[file_name] = lines_delta
        end
      end

      ##
      # It needs to diff the diff of before and after
      # with the coverage before the test suite in order
      # to include the uncovered lines to all tests that
      # touch this file
      def lines_cov_delta(before_suite, before, after)
        delta = diff before_suite, diff(before, after)
        delta.map(&method(:normalize_cov_result))
      end

      def diff(before, after)
        after = Array(after)
        before = Array(before)

        after.zip(before).map do |lines_after, lines_before|
          lines_after ? lines_after - lines_before.to_i : lines_after
        end
      end

      ##
      # The possible param value that this method might receive
      # are the following
      #
      # @param result positive => should be run the test
      # @param result negative => should be run the test
      # @param result nil      => should be run the test
      # @param result zero     => should not run the test
      #
      # This method will convert negative and nil values to 1,
      # which will make them represent lines that should be run.
      # The positive lines can be kept as they are since this mean
      # they will be run.
      #
      # The only exception case is the 0 result which will be kept
      # as it is so we don't run lines within the not called methods
      #
      # This introduces false positives to avoid missing tests that
      # depends on lines that are evaluated when the file is required
      #
      # @return 1 to represent that this line should trigger the current test
      # @return 0 to represent that this line should not trigger the current test
      def normalize_cov_result(result)
        result.nil? || result.to_i < 0 ? 1 : result
      end

      def file_covered?(cov_before, cov_after)
        cov_before != cov_after
      end
    end

    private_class_method :lines_cov_delta, :file_covered?
  end
end
