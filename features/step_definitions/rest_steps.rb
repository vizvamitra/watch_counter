When(/^(?:|I )send them to '([^']+)' via '([^']+)'$/) do |url, method|
  send(method, url, @data_to_send)
end

When(/^(?:|I )make a request to '([^']+)' via '([^']+)'$/) do |url, method|
  send(method, url)
end

Then(/^the response status should be (\d+)$/) do |status|
  expect(last_response.status).to be status.to_i
end

Then /^(?:|I )should see JSON:$/ do |expected_json|
  require 'json'
  expected = JSON.pretty_generate(JSON.parse(expected_json))
  actual   = JSON.pretty_generate(JSON.parse(last_response.body))
  expected.should == actual
end