require File.expand_path('sanity_shared_examples', File.dirname(__FILE__))

describe 'Minitest sanity test' do
  it_behaves_like 'a sanity check', 'minitest', 'rake test'
end
