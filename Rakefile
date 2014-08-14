require 'rake/testtask'

def scope(path)
  File.join(File.dirname(__FILE__), path)
end

desc 'Default Task'
task :test do
  Rake::TestTask.new do |t|
    t.libs << 'test'
    test_files = FileList[scope('test/**/test_helper.rb'), scope('test/**/*_test.rb')]
    t.test_files = test_files
    t.verbose = true
  end
end

task :default => :test