Feature: Smell selection
  In order to focus on particular code smells
  As a developer
  I want to be able to selectively activate smell detectors

  Scenario: --smell selects a smell to detect
    Given a minimal dirty file called 'minimal_dirty.rb'
    When I run reek --no-line-numbers --smell UncommunicativeMethodName minimal_dirty.rb
    Then the exit status indicates smells
    And it reports:
      """
      minimal_dirty.rb -- 1 warning:
        Smelly#m has the name 'm' (UncommunicativeMethodName)
      """
