Feature: Masking smells using config files
  In order to keep my reports meaningful
  As a developer
  I want to mask some smells using config files

  Scenario: empty config file is ignored
    Given a smelly file
    And an empty config file
    When I run reek -c empty.reek smelly.rb
    Then it reports the error 'Warning: Invalid configuration file "empty.reek" -- Empty file'
    And the exit status indicates smells
    And it reports:
      """
      smelly.rb -- 6 warnings:
        [5]:Dirty has the variable name '@s' (UncommunicativeVariableName)
        [4, 6]:Dirty#a calls @s.title 2 times (DuplicateMethodCall)
        [4, 6]:Dirty#a calls puts(@s.title) 2 times (DuplicateMethodCall)
        [5]:Dirty#a contains iterators nested 2 deep (NestedIterators)
        [3]:Dirty#a has the name 'a' (UncommunicativeMethodName)
        [5]:Dirty#a has the variable name 'x' (UncommunicativeVariableName)
      """

  Scenario: corrupt config file prevents normal output
    Given a smelly file
    And a corrupt config file
    When I run reek -c corrupt.reek smelly.rb
    Then it reports the error 'Error: Invalid configuration file "corrupt.reek" -- Not a hash'
    And the exit status indicates an error
    And it reports nothing

  Scenario: missing source file is an error
    When I run reek not_here.rb
    Then it reports the error "Error: No such file - not_here.rb"

  Scenario: masking smells in the config file
    Given a smelly file
    And a masking configuration file
    When I run reek -c config.reek smelly.rb
    Then the exit status indicates smells
    And it reports:
      """
      smelly.rb -- 3 warnings:
        [4, 6]:Dirty#a calls @s.title 2 times (DuplicateMethodCall)
        [4, 6]:Dirty#a calls puts(@s.title) 2 times (DuplicateMethodCall)
        [5]:Dirty#a contains iterators nested 2 deep (NestedIterators)
      """

  Scenario: allow masking some calls for duplication smell
    Given a smelly file
    And a configuration file masking some duplication smells
    When I run reek -c config.reek smelly.rb
    Then the exit status indicates smells
    And it reports:
      """
      smelly.rb -- 2 warnings:
        [4, 6]:Dirty#a calls @s.title 2 times (DuplicateMethodCall)
        [5]:Dirty#a contains iterators nested 2 deep (NestedIterators)
      """

  Scenario: provide extra masking inline in comments
    Given a smelly file with inline masking
    And a masking configuration file
    When I run reek -c config.reek inline.rb
    Then the exit status indicates smells
    And it reports:
      """
      inline.rb -- 1 warning:
        [5, 7]:Dirty#a calls @s.title 2 times (DuplicateMethodCall)
      """
