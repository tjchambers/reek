Given(/^a demo directory with a smelly file$/) do
  contents = <<-EOS
class Dirty
  # This method smells of :reek:NestedIterators but ignores them
  def awful(x, y, offset = 0, log = false)
    puts @screen.title
    @screen = widgets.map {|w| w.each {|key| key += 3}}
    puts @screen.contents
  end
end
  EOS
  write_file('demo/demo.rb', contents)
end

Given(/^a smelly file$/) do
  contents = <<-EOS
# smelly class for testing purposes
class Dirty
  def a
    puts @s.title
    @s = fred.map {|x| x.each {|key| key += 3}}
    puts @s.title
  end
end
  EOS
  write_file('smelly.rb', contents)
end

Given(/^a smelly file with inline masking$/) do
  write_file 'inline.rb', <<-EOS
# :reek:DuplicateMethodCall: { allow_calls: [ puts ] }
# smells of :reek:NestedIterators but ignores them
class Dirty
  def a
    puts @s.title
    @s = fred.map {|x| x.each {|key| key += 3}}
    puts @s.title
  end

  # :reek:DuplicateMethodCall: { max_calls: 2 }
  def b
    puts @s.title
    @s = fred.map {|x| x.each {|key| key += 3}}
    puts @s.title
  end
end
  EOS
end

Given(/^the "(.*?)" sample file exists$/) do |file_name|
  full_path = File.expand_path file_name, 'spec/samples'
  in_current_dir { FileUtils.cp full_path, file_name }
end

Given(/^a directory with clean files$/) do
  contents = <<-EOS
# clean class for testing purposes
class Clean
  def assign
    puts @sub.title
    @sub.map {|para| para.name }
  end
end
  EOS
  write_file 'clean_files/clean_one.rb', contents
  write_file 'clean_files/clean_two.rb', contents
  write_file 'clean_files/clean_three.rb', contents
end

Given(/^a directory with two smelly files$/) do
  contents = <<-EOS
# smelly class for testing purposes
class Dirty
  def a
    puts @s.title
    @s = fred.map {|x| x.each {|key| key += 3}}
    puts @s.title
  end
end
  EOS
  write_file('smelly/dirty_one.rb', contents)
  write_file('smelly/dirty_two.rb', contents)
end

Given(/^a directory with three different smelly files$/) do
  write_file('smelly/dirty_one.rb', <<-EOS)
class Dirty
  def a; end
end
  EOS
  write_file('smelly/dirty_two.rb', <<-EOS)
class Dirty
  def a; end
  def b; end
end
  EOS
  write_file('smelly/dirty_three.rb', <<-EOS)
class Dirty
  def a; end
  def b; end
  def c; end
end
  EOS
end

Given(/^a minimal dirty file$/) do
  write_file 'minimal_dirty.rb', <<-EOS
class C
  def m
  end
end
  EOS
end

Given(/^a file with smelly variable names$/) do
  write_file('camel_case.rb', <<-EOS)
# Class containing camelCase variable which would normally smell
class CamelCase
  def initialize
    # These next two would normally smell if it weren't for overridden config values
    camelCaseVariable = []
    anotherOne = 1

    # this next one should still smell
    x1 = 0

    # this next one should not smell
    should_not_smell = true
  end
end
  EOS
end

Given(/^an empty config file$/) do
  write_file('empty.reek', '')
end

Given(/^a corrupt config file$/) do
  write_file('corrupt.reek', 'This is not a config file')
end

Given(/^a masking configuration file$/) do
  write_file('config.reek', <<-EOS)
---
IrresponsibleModule:
  enabled: false
UncommunicativeVariableName:
  enabled: false
UncommunicativeModuleName:
  enabled: false
UncommunicativeMethodName:
  enabled: false
UnusedParameters:
  enabled: false
  EOS
end

Given(/^a configuration file masking some duplication smells$/) do
  write_file('config.reek', <<-EOS)
---
DuplicateMethodCall:
  allow_calls:
    - puts\\(@s.title\\)
UncommunicativeVariableName:
  enabled: false
UncommunicativeMethodName:
  enabled: false
  EOS
end

Given(/^a configuration allowing camel case variables$/) do
  write_file('config.reek', <<-EOS)
---
UncommunicativeVariableName:
  enabled: true
  reject:
  - !ruby/regexp /^.$/
  - !ruby/regexp /[0-9]$/
  EOS
end

Given(/^a minimal dirty file in a subdirectory$/) do
  write_file 'subdir/minimal_dirty.rb', <<-EOS
class C
  def m
  end
end
  EOS
end

When(/^I run "reek (.*?)" in the subdirectory$/) do |args|
  cd 'subdir'
  reek(args)
end

Given(/^a masking configuration file in the HOME directory$/) do
  set_env('HOME', File.expand_path(File.join(current_dir, 'home')))
  write_file('home/config.reek', <<-EOS)
---
IrresponsibleModule:
  enabled: false
UncommunicativeModuleName:
  enabled: false
UncommunicativeMethodName:
  enabled: false
  EOS
end

Given(/^an enabling configuration file in the subdirectory$/) do
  write_file('subdir/config.reek', <<-EOS)
---
IrresponsibleModule:
  enabled: true
UncommunicativeModuleName:
  enabled: true
UncommunicativeMethodName:
  enabled: true
  EOS
end
