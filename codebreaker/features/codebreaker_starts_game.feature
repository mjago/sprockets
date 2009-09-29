
Feature: codebreaker starts game

As a codebreaker
I want to start a game
So that I can break the code

Scenario: start game
Given I am not yet playing
When I start a new game
Then the game should say "Welcome to Codebreaker!"
And the game should say "Enter guess:"
