# Rakefile

task :default => :test

task :test do
  test_files = FileList['test/**/*_test.rb']
  test_files.each do |file|
    sh "ruby -Ilib:test #{file}"
  end
end
