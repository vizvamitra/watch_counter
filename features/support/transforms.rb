Transform(/^(GET|POST|PUT|PATCH|DELETE)$/) do |method|
  method.downcase.to_sym
end