Feature: Smell selection
  In order to focus on particular code smells
  As a developer
  I want to be able to selectively activate smell detectors

  Scenario: --smell selects a smell to detect
    Given a smelly file
    When I run reek --no-line-numbers --smell DuplicateMethodCall smelly.rb
    Then the exit status indicates smells
    And it reports:
      """
      smelly.rb -- 2 warnings:
        Dirty#a calls @s.title 2 times (DuplicateMethodCall)
        Dirty#a calls puts(@s.title) 2 times (DuplicateMethodCall)
      """
