Given(/^customer (\d+) is currently watching (\d+) videos?$/) do |customer_id, watches_count|
  storage = WatchCounter.app.storage
  watches_count.to_i.times do |i|
    storage.register_watch(customer_id, i+1)
  end
end

Given(/^video (\d+) is currently being watched by (\d+) customers$/) do |video_id, watches_count|
  storage = WatchCounter.app.storage
  watches_count.to_i.times do |i|
    storage.register_watch(i+1, video_id)
  end
end

When(/^(?:|I )take the following data:$/) do |table|
  @data_to_send = table.rows_hash
end