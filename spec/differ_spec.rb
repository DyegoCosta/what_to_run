require 'what_to_run/differ'

describe WhatToRun::Differ do
  subject {WhatToRun::Differ}

  describe 'coverage_delta' do
    let(:before) do
      {
        'foo.rb' =>               [nil, 1,   1,   1, 2,   nil],
        'not_changed.rb' =>       [nil, nil, nil, 1, nil, nil],
        'nil_initial_coverage' => nil
      }
    end

    let(:after) do
      {
        'foo.rb' =>               [nil, 1,   2,   3, 2,   nil],
        'not_changed.rb' =>       [nil, nil, nil, 1, nil, nil],
        'nil_initial_coverage' => [1, 3, nil]
      }
    end

    let(:delta) {subject.coverage_delta(before, after)}

    it 'subtracts the old coverage from the new one' do
      expect(delta['foo.rb']).to \
        match_array([nil, 0, 1, 2, 0, nil])
    end

    it 'doest not include unchanged coverages' do
      expect(delta['not_changed.rb']).to be_nil
    end

    it 'keeps after data if before data is empty' do
      expect(delta['nil_initial_coverage']).to \
        match_array(after['nil_initial_coverage'])
    end
  end
end
