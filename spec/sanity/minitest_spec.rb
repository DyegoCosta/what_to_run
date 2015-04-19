require File.expand_path('sanity_shared_examples', File.dirname(__FILE__))

describe 'Minitest sanity test' do
  it_behaves_like 'a sanity check', 'minitest', 'rake test' do
    let(:what_to_run_result_matches) do
      [
        '1 runs, 0 assertions, 0 failures, 1 errors, 0 skips'
      ]
    end
  end
end
