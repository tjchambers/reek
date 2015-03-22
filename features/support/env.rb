require 'reek/cli/application'
require 'aruba/cucumber'

begin
  require 'pry-byebug'
rescue LoadError # rubocop:disable Lint/HandleExceptions
end

#
# Provides runner methods used in the cucumber steps.
#
class ReekWorld
  def reek(args)
    run_simple("reek --no-color #{args}", false)
  end

  def reek_with_pipe(stdin, args)
    run_interactive("reek --no-color #{args}")
    type(stdin)
    close_input
  end

  def rake(name, task_def)
    header = <<EOS
$:.unshift('lib')
require 'reek/rake/task'

EOS
    write_file 'Rakefile', header + task_def
    run_simple("rake #{name}", false)
  end
end

World do
  ReekWorld.new
end
