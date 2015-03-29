require 'spec_helper'

describe 'WhatToRun' do
  describe '#predict' do
    let(:lines_to_run) do
      [['/path/to/lib/foo.rb', 7], ['/path/to/lib/bar.rb', 4]]
    end

    let(:cov_map) do
      {
        '/path/to/lib/foo.rb' => {
          3 => ['Test Foo 1', 'Test Foo 2'],
          7 => ['Test Foo 3']
        },
        '/path/to/lib/bar.rb' => {
          4 => ['Test Bar 4', 'Test Bar 5'],
          9 => ['Test Bar 6']
        }
      }
    end

    before do
      allow(WhatToRun).to receive(:cov_map).and_return(cov_map)
      allow(WhatToRun).to receive(:lines_to_run).and_return(lines_to_run)
    end

    it 'looks up tests by file name and line number' do
      expect(WhatToRun.predict).to \
        match_array ['Test Foo 3', 'Test Bar 4', 'Test Bar 5']
    end

    it 'does not include unmatched tests' do
      expect(WhatToRun.predict).not_to \
        include 'Test Bar 6', 'Test Foo 1', 'Test Foo 2'
    end
  end
end
