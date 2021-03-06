require 'support/fake_api'
require 'support/fake_github'
require 'support/helpers'

require 'fileutils'
require 'travis'
require 'highline'
require 'tmpdir'
require 'pry' # pry doesn't like us mocking $stdout

temp_dir = nil

RSpec.configure do |c|
  c.include Helpers

  c.before do
    HighLine.use_color = false
    temp_dir = File.expand_path('travis-spec', Dir.tmpdir)
    FileUtils.rm_rf(temp_dir)
    FileUtils.mkdir_p(temp_dir)
    ENV['TRAVIS_CONFIG_PATH'] = File.expand_path('travis', temp_dir)
  end

  c.after do
    FileUtils.rm_rf(temp_dir)
  end
end
