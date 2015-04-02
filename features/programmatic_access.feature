Feature: Using reek programmatically
  In order to use reek from inside my program
  As a developer
  I want to be able to use its classes

  Scenario:
    Given a smelly file
    And a file named "examine.rb" with:
      """
      require 'reek'
      examiner = Reek::Examiner.new(['smelly.rb'])
      examiner.smells.each do |smell|
        puts smell.message
      end
      """
    When I run `ruby examine.rb`
    Then it reports no errors
    And it reports:
      """
      has the variable name '@s'
      calls @s.title 2 times
      calls puts(@s.title) 2 times
      contains iterators nested 2 deep
      has the name 'a'
      has the variable name 'x'
      """

