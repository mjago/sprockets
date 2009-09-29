
Given /^I am not yet playing$/ do
  pending
end

When /^I start a new game$/ do
  Codebreaker::Game.new
  @messages = game.start
end

Then /^the game should say "([^\"]*)"$/ do |message|
  @messages.should include( message )
end

Given /^the secret code is r g y c$/ do
  pending
end

When /^I guess r g y c$/ do
  pending
end

Then /^the mark should be bbbb$/ do
  pending
end

When /^I guess r g c y$/ do
  pending
end

Then /^the mark should be bbww$/ do
  pending
end

When /^I guess y r g c$/ do
  pending
end

Then /^the mark should be bwww$/ do
  pending
end

When /^I guess c r g y$/ do
  pending
end

Then /^the mark should be wwww$/ do
  pending
end

When /^I guess w g y c$/ do
  pending
end

Then /^the mark should be bbb$/ do
  pending
end

When /^I guess w r y c$/ do
  pending
end

Then /^the mark should be bbw$/ do
  pending
end

When /^I guess w r g c$/ do
  pending
end

Then /^the mark should be bww$/ do
  pending
end

When /^I guess w r g y$/ do
  pending
end

Then /^the mark should be www$/ do
  pending
end

When /^I guess w g w c$/ do
  pending
end

Then /^the mark should be bb$/ do
  pending
end

When /^I guess w r w c$/ do
  pending
end

Then /^the mark should be bw$/ do
  pending
end

When /^I guess g w w c$/ do
  pending
end

Then /^the mark should be ww$/ do
  pending
end

When /^I guess r w w w$/ do
  pending
end

Then /^the mark should be b$/ do
  pending
end

When /^I guess w w r w$/ do
  pending
end

Then /^the mark should be w$/ do
  pending
end



