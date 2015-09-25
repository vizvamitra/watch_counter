Given(/^I have (\d+) video watches for customer (\d+)$/) do |watches_count, customer_id|
  storage = WatchCounter::Settings.get(:storage)
  watches_count.to_i.times do |i|
    storage.register_watch(customer_id, i+1)
  end
end

When(/^(?:|I )take the following data:$/) do |table|
  @data_to_send = table.rows_hash
end