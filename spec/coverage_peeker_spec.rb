require 'tmpdir'
require 'coverage'
require 'coverage_peeker'

describe CoveragePeeker do
  it 'raise error if coverage is not started' do
    expect {CoveragePeeker.peek_result}.to \
      raise_error(RuntimeError)
  end

  it 'builds coverage snapshot' do
    Dir.mktmpdir do |tmp|
      Dir.chdir(tmp) do
        File.open("test.rb", "w") do |f|
          f.puts <<-EOS
              def coverage_test_method
                :ok
              end
          EOS
        end

        test_path = tmp + '/test.rb'

        Coverage.start

        require test_path

        before_test = CoveragePeeker.peek_result[test_path]
        coverage_test_method
        after_test = CoveragePeeker.peek_result[test_path]
        final_result = Coverage.result[test_path]

        expect(after_test[1]).to eq before_test[1] + 1
        expect(final_result).to eq after_test
      end
    end
  end
end
