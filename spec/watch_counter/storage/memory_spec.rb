require_relative '../../spec_helper'

describe WatchCounter::Storage::Memory do
  let(:storage){ described_class.new() }

  it_behaves_like 'storage adapter'
end