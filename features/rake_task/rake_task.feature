Feature: Reek can be driven through its Task
  Reek provides an easy way to integrate its use into Rakefiles,
  via the Task class. These scenarios test its various options.

  Scenario: source_files points at the desired files
    Given a minimal dirty file called 'minimal_dirty.rb'
    When I run rake reek with:
      """
      Reek::Rake::Task.new do |t|
        t.source_files = 'minimal_dirty.rb'
        t.reek_opts = '--no-color'
      end
      """
    Then the exit status indicates an error
    And it reports:
      """
      minimal_dirty.rb -- 3 warnings:
        [1]:C has no descriptive comment (IrresponsibleModule)
        [1]:C has the name 'C' (UncommunicativeModuleName)
        [2]:C#m has the name 'm' (UncommunicativeMethodName)
      """

  Scenario: name changes the task name
    Given a minimal dirty file called 'minimal_dirty.rb'
    When I run rake silky with:
      """
      Reek::Rake::Task.new('silky') do |t|
        t.source_files = 'minimal_dirty.rb'
        t.reek_opts = '--no-color'
      end
      """
    Then the exit status indicates an error
    And it reports:
      """
      minimal_dirty.rb -- 3 warnings:
        [1]:C has no descriptive comment (IrresponsibleModule)
        [1]:C has the name 'C' (UncommunicativeModuleName)
        [2]:C#m has the name 'm' (UncommunicativeMethodName)
      """

  Scenario: verbose prints the reek command
    Given a minimal dirty file called 'minimal_dirty.rb'
    When I run rake reek with:
      """
      Reek::Rake::Task.new do |t|
        t.source_files = 'minimal_dirty.rb'
        t.verbose = true
      end
      """
    Then the exit status indicates an error
    And stdout includes "Running 'reek' rake command"

  Scenario: fail_on_error can hide the error status
    Given a minimal dirty file called 'minimal_dirty.rb'
    When I run rake reek with:
      """
      Reek::Rake::Task.new do |t|
        t.fail_on_error = false
        t.source_files = 'minimal_dirty.rb'
        t.reek_opts = '--no-color'
      end
      """
    Then it reports no errors
    And it succeeds
    And it reports:
      """
      minimal_dirty.rb -- 3 warnings:
        [1]:C has no descriptive comment (IrresponsibleModule)
        [1]:C has the name 'C' (UncommunicativeModuleName)
        [2]:C#m has the name 'm' (UncommunicativeMethodName)
      """

  Scenario: can be configured with config_file
    Given a minimal dirty file called 'minimal_dirty.rb'
    And a masking configuration file called 'config.reek'
    When I run rake reek with:
      """
      Reek::Rake::Task.new do |t|
        t.config_file  = 'config.reek'
        t.source_files = 'minimal_dirty.rb'
      end
      """
    Then it succeeds
    And it reports nothing
