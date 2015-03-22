Feature: Offer different ways how to load configuration

  There are 3 ways of passing reek a configuration file:
  - Using the cli "-c" switch
  - Having a file ending with .reek either in your current working directory or in a parent directory
  - Having a file ending with .reek in your HOME directory
  The order in which reek tries to find such a configuration file should exactly be like above:
  First reek should check if we have given it a configuration file explicitly via CLI.
  Then it should check the current working directory for a file and if it can't find one,
  it should traverse up the directories until it hits the root directory.
  And finally, it should check your HOME directory.

  Scenario: No configuration
    Given a minimal dirty file
    When I run reek minimal_dirty.rb
    Then the exit status indicates smells
    And it reports:
      """
      minimal_dirty.rb -- 3 warnings:
        [1]:C has no descriptive comment (IrresponsibleModule)
        [1]:C has the name 'C' (UncommunicativeModuleName)
        [2]:C#m has the name 'm' (UncommunicativeMethodName)
      """

  Scenario: Configuration via CLI
    Given a minimal dirty file
    And a masking configuration file
    When I run reek -c config.reek minimal_dirty.rb
    Then it reports no errors
    And it succeeds

  @remove-disable-smell-config-from-current-dir
  Scenario: Configuration file in working directory
    Given a minimal dirty file
    Given "spec/samples/configuration_loading/reek-test-run-disable_smells.reek" exists in the working directory
    When I run reek minimal_dirty.rb
    Then it reports no errors
    And it succeeds

  @remove-disable-smell-config-from-parent-dir
  Scenario: Configuration file in the parent directory of the working directory
    Given a minimal dirty file
    Given "spec/samples/configuration_loading/reek-test-run-disable_smells.reek" exists in the parent directory of the working directory
    When I run reek minimal_dirty.rb
    Then it reports no errors
    And it succeeds

  @remove-disable-smell-config-from-home-dir
  Scenario: Configuration file in the HOME directory
    Given a minimal dirty file
    Given "spec/samples/configuration_loading/reek-test-run-disable_smells.reek" exists in the HOME directory
    When I run reek minimal_dirty.rb
    Then it reports no errors
    And it succeeds

  @remove-enable-smell-config-from-current-dir @remove-disable-smell-config-from-parent-dir
  Scenario: Two opposing configuration files and we stop after the first one
    Given a minimal dirty file
    Given "spec/samples/configuration_loading/reek-test-run-enable_smells.reek" exists in the working directory
    And "spec/samples/configuration_loading/reek-test-run-disable_smells.reek" exists in the parent directory of the working directory
    When I run reek minimal_dirty.rb
    Then the exit status indicates smells
    And it reports:
      """
      minimal_dirty.rb -- 3 warnings:
        [1]:C has no descriptive comment (IrresponsibleModule)
        [1]:C has the name 'C' (UncommunicativeModuleName)
        [2]:C#m has the name 'm' (UncommunicativeMethodName)
      """
