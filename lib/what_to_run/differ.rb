module WhatToRun
  class Differ
    class << self
      def coverage_delta(before, after)
        after.each_with_object({}) do |(file_name, after_lines_cov), delta|
          before_lines_cov = before[file_name]

          # skip arrays that are exactly the same
          next if before_lines_cov == after_lines_cov

          # subtract the old coverage from the new coverage
          lines_delta = lines_cov_delta(before_lines_cov, after_lines_cov)

          # add the "diffed" coverage to the hash
          delta[file_name] = lines_delta
        end
      end

      def lines_cov_delta(before_lines_cov, after_lines_cov)
        after = Array(after_lines_cov)
        before = Array(before_lines_cov)

        after.zip(before).map do |lines_after, lines_before|
          lines_after ? lines_after - lines_before.to_i : lines_after
        end
      end
    end

    private_class_method :lines_cov_delta
  end
end
