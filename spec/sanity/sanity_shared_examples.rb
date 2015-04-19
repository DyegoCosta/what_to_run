shared_examples 'a sanity check' do |framework, run_cmd|
  describe framework, :slow do
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

      describe 'what_to_run command' do
        let(:what_to_run_result) { @what_to_run_result }
        let(:process_status) { @process_status }

        let(:what_to_run) do
          -> do
            reader, writer = IO.pipe

            fork do
              reader.close

              writer.write `cd #{sandbox_app_path} &&
                BUNDLE_GEMFILE=./Gemfile bundle exec what_to_run #{framework}`
            end

            @process_status = Process.wait2[1]

            writer.close

            @what_to_run_result = reader.read
          end
        end

        context 'without any changes' do
          it 'runs nothing' do
            what_to_run.call
            expect(process_status.exitstatus).to eq(0)
            expect(what_to_run_result).to eq('')
          end
        end

        context 'after modifying lib files' do
          before do
            Dir["#{sandbox_app_path}/lib/*_modified.rb"].each do |modified|
              FileUtils.cp modified, modified.gsub('_modified', '')
            end
          end

          it 'runs the predicted examples' do
            what_to_run.call

            what_to_run_result_matches.each do |match|
              expect(what_to_run_result).to include(match)
            end
          end
        end
      end
    end
  end
end
