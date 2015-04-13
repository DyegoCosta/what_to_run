require 'what_to_run/tracker'

describe WhatToRun::Tracker do
  subject {described_class}

  describe '.additional_databases' do
    it 'returns empty array if just one db exists' do
      allow(Dir).to receive(:[]).and_return ['run_log.db']
      expect(subject.send(:additional_databases)).to eq([])
    end

    it 'returns additional databases names if more than one exist' do
      allow(Dir).to receive(:[]).and_return \
        ['run_log.db', 'run_log2.db', 'run_log3.db']

      expect(subject.send(:additional_databases)).to \
        eq(['run_log2', 'run_log3'])
    end
  end

  context 'with additional databases' do
    before do
      allow(subject).to receive(:additional_databases)
        .and_return(['db2', 'db3'])
    end

    describe '.attach_databases!' do
      it 'attaches databases with numbered suffix starting from 2' do
        expect(subject::DB).to receive(:execute).once
          .with("attach '.what_to_run/db2.db' as db2")

        expect(subject::DB).to receive(:execute).once
          .with("attach '.what_to_run/db3.db' as db3")

        subject.send(:attach_databases!)
      end
    end

    describe '.union_query' do
      it 'concats union query for each additional database' do
        expect(subject.send(:union_query)).to eq \
          ' union select description, log from db2.coverage' \
          ' union select description, log from db3.coverage' \
      end
    end
  end
end
