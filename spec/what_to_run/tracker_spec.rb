require 'what_to_run/tracker'

describe WhatToRun::Tracker do
  subject {described_class}

  describe '.attach_databases!' do
    it 'attaches databases with numbered suffix starting from 2' do
      expect(subject::DB).to receive(:execute).once
        .with("attach '.what_to_run/run_log2.db' as db2")

      expect(subject::DB).to receive(:execute).once
        .with("attach '.what_to_run/run_log3.db' as db3")

      subject.send(:attach_databases!, 3)
    end
  end

  describe '.union_query' do
    it 'concats union query for each additional database' do
      expect(subject.send(:union_query, 2)).to eq \
        ' union select description, log from db2.coverage'
    end
  end
end
