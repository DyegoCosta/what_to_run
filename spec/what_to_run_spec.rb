require 'spec_helper'
require 'json'

describe WhatToRun do
  describe 'predict' do
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

  describe 'cov_map' do
    let(:cov_map) {WhatToRun.cov_map}
    let(:run_log) {double(File, read: run_log_data)}

    before do
      allow(File).to receive(:open) do |&block|
        block.call(run_log)
      end
    end

    shared_examples 'cov_map' do
      it 'maps only coveraged lines' do
        {
          foo: [2, 4, 5],
          bar: [2, 3, 4]
        }.each_pair do |file, lines|
          expect(cov_map["path/to/#{file}.rb"].keys).to \
            match_array lines
        end
      end

      it 'maps lines covered by Foo test' do
        [2, 4, 5].each do |line|
          expect(cov_map['path/to/foo.rb'][line]).to \
            match_array [foo_test_name]
        end
      end

      it 'maps lines covered by Bar test' do
        [2, 3].each do |line|
          expect(cov_map['path/to/bar.rb'][line]).to \
            match_array [bar_test_name]
        end
      end

      it 'maps lines covered by both Foo and Bar tests' do
        expect(cov_map['path/to/bar.rb'][4]).to \
          match_array [bar_test_name, foo_test_name]
      end
    end

    context 'rspec' do
      let(:foo_test_name) {'Test Foo'}
      let(:bar_test_name) {'Test Bar'}
      let(:run_log_data) do
        [
          [
            'Test Foo',
            {
              'path/to/foo.rb' => [nil, 0, 1, 0, 1, nil],
              'path/to/bar.rb' => [nil, nil, nil, 0, nil, nil]
            },
            {
              'path/to/foo.rb' => [nil, 1, 1, 1, 2, nil],
              'path/to/bar.rb' => [nil, nil, nil, 1, nil, nil]
            }
          ],
          [
            'Test Bar',
            {
              'path/to/foo.rb' => [nil, nil, 1, nil, 1, nil],
              'path/to/bar.rb' => [nil, 0, 0, 1, nil, nil]
            },
            {
              'path/to/foo.rb' => [nil, nil, 1, nil, 1, nil],
              'path/to/bar.rb' => [nil, 1, 1, 2, nil, nil]
            }
          ]
        ].to_json
      end

      it_behaves_like 'cov_map'
    end

    context 'minitest' do
      let(:foo_test_name) {'TestClass#test_foo'}
      let(:bar_test_name) {'TestClass#test_bar'}
      let(:run_log_data) do
        [
          [
            'TestClass',
            'test_foo',
            {
              'path/to/foo.rb' => [nil, 0, 1, 0, 1, nil],
              'path/to/bar.rb' => [nil, nil, nil, 0, nil, nil]
            },
            {
              'path/to/foo.rb' => [nil, 1, 1, 1, 2, nil],
              'path/to/bar.rb' => [nil, nil, nil, 1, nil, nil]
            }
          ],
          [
            'TestClass',
            'test_bar',
            {
              'path/to/foo.rb' => [nil, nil, 1, nil, 1, nil],
              'path/to/bar.rb' => [nil, 0, 0, 1, nil, nil]
            },
            {
              'path/to/foo.rb' => [nil, nil, 1, nil, 1, nil],
              'path/to/bar.rb' => [nil, 1, 1, 2, nil, nil]
            }
          ]
        ].to_json
      end

      it_behaves_like 'cov_map'
    end
  end
end
