require 'json'
require 'what_to_run'

describe WhatToRun do
  describe '.predict' do
    let(:lines_to_run) do
      [['/path/to/foo.rb', 7], ['/path/to/bar.rb', 4]]
    end

    let(:cov_map) do
      {
        '/path/to/foo.rb' => {
          3 => ['Test Foo 1', 'Test Foo 2'],
          7 => ['Test Foo 3']
        },
        '/path/to/bar.rb' => {
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

  describe '.cov_map' do
    let(:cov_map) {WhatToRun.cov_map}

    before do
      allow(WhatToRun::Tracker).to \
        receive(:read) {|&block| coverage_delta.each(&block)}
    end

    let(:coverage_delta) do
      [
        [
          'Test Foo',
          {
            'path/to/foo.rb' => [nil, 1,   1,   1, 2,   nil],
            'path/to/bar.rb' => [nil, nil, nil, 1, nil, nil]
          }
        ],
        [
          'Test Bar',
          {
            'path/to/foo.rb' => [nil, nil, nil, 1, 1,   nil],
            'path/to/bar.rb' => [nil, 1,   1,   2, nil, nil]
          }
        ]
      ]
    end

    it 'maps only coveraged lines' do
      {
        foo: [2, 3, 4, 5],
        bar: [2, 3, 4]
      }.each_pair do |file, lines|
        expect(cov_map["path/to/#{file}.rb"].keys).to \
          match_array lines
      end
    end

    it 'maps lines covered just by Foo test' do
      [2, 3].each do |line|
        expect(cov_map['path/to/foo.rb'][line]).to \
          match_array ['Test Foo']
      end
    end

    it 'maps lines covered just by Bar test' do
      [2, 3].each do |line|
        expect(cov_map['path/to/bar.rb'][line]).to \
          match_array ['Test Bar']
      end
    end

    it 'maps lines covered by both Foo and Bar tests' do
      expect(cov_map['path/to/bar.rb'][4]).to \
        match_array ['Test Bar', 'Test Foo']
    end
  end
end
