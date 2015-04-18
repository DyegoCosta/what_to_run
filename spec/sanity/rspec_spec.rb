require File.expand_path('sanity_shared_examples', File.dirname(__FILE__))

describe 'RSpec sanity test' do
  it_behaves_like 'a sanity check', 'rspec', 'rspec'
end
