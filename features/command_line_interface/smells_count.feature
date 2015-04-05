Feature: Reports total number of code smells
  In order to monitor the total number of smells
  Reek outputs the total number of smells among all files inspected.

  Scenario: Does not output total number of smells when inspecting single file
    Given a smelly file called 'smelly.rb'
    When I run reek smelly.rb
    Then the exit status indicates smells
    And it reports:
    """
    smelly.rb -- 3 warnings:
      [4, 5]:Smelly#m calls @foo.bar 2 times (DuplicateMethodCall)
      [4, 5]:Smelly#m calls puts(@foo.bar) 2 times (DuplicateMethodCall)
      [3]:Smelly#m has the name 'm' (UncommunicativeMethodName)
    """

  Scenario: Output total number of smells when inspecting multiple files
    Given a directory called 'smelly' containing two smelly files
    When I run reek smelly
    Then the exit status indicates smells
    And it reports:
    """
    smelly/dirty_one.rb -- 6 warnings:
      [5]:Dirty has the variable name '@s' (UncommunicativeVariableName)
      [4, 6]:Dirty#a calls @s.title 2 times (DuplicateMethodCall)
      [4, 6]:Dirty#a calls puts(@s.title) 2 times (DuplicateMethodCall)
      [5]:Dirty#a contains iterators nested 2 deep (NestedIterators)
      [3]:Dirty#a has the name 'a' (UncommunicativeMethodName)
      [5]:Dirty#a has the variable name 'x' (UncommunicativeVariableName)
    smelly/dirty_two.rb -- 6 warnings:
      [5]:Dirty has the variable name '@s' (UncommunicativeVariableName)
      [4, 6]:Dirty#a calls @s.title 2 times (DuplicateMethodCall)
      [4, 6]:Dirty#a calls puts(@s.title) 2 times (DuplicateMethodCall)
      [5]:Dirty#a contains iterators nested 2 deep (NestedIterators)
      [3]:Dirty#a has the name 'a' (UncommunicativeMethodName)
      [5]:Dirty#a has the variable name 'x' (UncommunicativeVariableName)
    12 total warnings
    """

  Scenario: Output total number of smells even if total equals 0
    Given a directory called 'clean_files' containing some clean files
    When I run reek clean_files
    Then it succeeds
    And it reports:
    """
    0 total warnings
    """
