namespace :gitlab do
  desc "GITLAB | Run all tests"
  task :test do
    cmds = [
      "rake db:setup",
      "rake db:seed_fu",
      "rake spinach --trace",
      "rake spec --trace",
      "rake jasmine:ci --trace"
    ]

    cmds.each do |cmd|
      system(cmd + " RAILS_ENV=test")

      raise "#{cmd} failed!" unless $?.exitstatus.zero?
    end
  end
end
