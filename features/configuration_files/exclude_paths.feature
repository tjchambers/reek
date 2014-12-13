Feature: Exclude paths
  In order to keep my reports meaningful
  As a developer
  I want to exclude paths from scanning

  Scenario: 2 directories and 1 file with the file and one directory being excluded
    When I run reek spec/samples/exclude_paths
    Then the exit status indicates smells
    And it reports:
      """
      spec/samples/exclude_paths/scan_me/dirty.rb -- 3 warnings:
        [1]:C has no descriptive comment (IrresponsibleModule)
        [1]:C has the name 'C' (UncommunicativeModuleName)
        [2]:C#m1 has the name 'm1' (UncommunicativeMethodName)
      """
