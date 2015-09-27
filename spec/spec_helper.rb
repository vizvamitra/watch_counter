$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'watch_counter'
require 'timecop'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.order = :random

  Kernel.srand config.seed
end