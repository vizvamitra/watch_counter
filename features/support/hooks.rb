# drop database before each scenario
Before do |scenario|
  @storage = WatchCounter.app.instance_variable_set(:@storage, nil)
end