shared_examples 'a sanity check' do |framework, run_cmd|
  describe framework do
    let(:sandbox_uuid) { SecureRandom.uuid[0..7] }
    let(:app_path) { File.expand_path('fake_app', File.dirname(__FILE__)) }
    let(:sandbox_path)  { File.expand_path(sandbox_uuid, File.dirname(__FILE__)) }
    let(:sandbox_app_path) { File.join(sandbox_path, 'fake_app')}

    before do
      FileUtils.mkdir sandbox_path
      FileUtils.cp_r app_path, sandbox_app_path
    end

    after { FileUtils.rm_r sandbox_path }

    context 'collecting' do
      let(:what_to_run_dir) { File.join(sandbox_app_path, '.what_to_run') }

      before do
        fork do
          `cd #{sandbox_app_path} &&
            BUNDLE_GEMFILE=./Gemfile COLLECT=1 bundle exec #{run_cmd}`
        end

        Process.wait
      end

      it 'creates .what_to_run dir' do
        expect(Dir.exist?(what_to_run_dir)).to be_truthy
      end

      it 'creates log_run.db' do
        run_log_path = File.join(what_to_run_dir, 'run_log.db')
        expect(File.exist?(run_log_path)).to be_truthy
      end
    end
  end
end
