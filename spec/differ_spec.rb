require 'what_to_run/differ'

describe WhatToRun::Differ do
  subject {WhatToRun::Differ}

  describe 'coverage_delta' do
    let(:before_suite) do
      {
        'foo.rb' =>               [nil, 1,   0,   0, 0,   nil],
        'not_changed.rb' =>       [nil, nil, nil, 1, nil, nil],
        'nil_initial_coverage' => nil
      }
    end

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

    let(:delta) {subject.coverage_delta(before, after, before_suite)}

    it 'turns calculated negative results into 1' do
      expect(delta['foo.rb'][1]).to eq(1)
    end

    it 'turns nil results into 1' do
      expect(delta['foo.rb'].first).to eq(1)
      expect(delta['foo.rb'].last).to eq(1)
    end

    it 'subtracts the old coverages from the new one' do
      expect(delta['foo.rb']).to \
        match_array([1, 1, 1, 2, 0, 1])
    end

    it 'doest not include unchanged coverages' do
      expect(delta['not_changed.rb']).to be_nil
    end

    it 'normalize after data if before data is empty' do
      expect(delta['nil_initial_coverage']).to \
        match_array([1, 3, 1])
    end

    describe 'normalize_cov_result' do
      it 'turns negative values into 1' do
        expect(subject.normalize_cov_result(-1)).to eq(1)
      end

      it 'turns nil values into 1' do
        expect(subject.normalize_cov_result(nil)).to eq(1)
      end

      it 'doesnt change 0' do
        expect(subject.normalize_cov_result(0)).to eq(0)
      end

      it 'doesnt change positive values' do
        expect(subject.normalize_cov_result(2)).to eq(2)
      end
    end
  end
end
