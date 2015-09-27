require_relative '../spec_helper'

describe WatchCounter::SqliteMemoryStorage do
  it_behaves_like 'storage adapter'
end