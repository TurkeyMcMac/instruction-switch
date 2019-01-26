load "exception.rb"
load "instruction.rb"
load "table.rb"
load "parser.rb"
load "cli.rb"

begin
  settings = get_settings(ARGV)
  code = Parser.create(read_table(settings[:input_file]), settings).generate
  output = settings[:output_file]
  if output.is_a? String
    output = File.open(output, "w")
  end
  output.puts(code)
rescue UserInputError, OptionParser::ParseError => e
  STDERR.puts "#{$0}: #{e}"
  exit 1
end
