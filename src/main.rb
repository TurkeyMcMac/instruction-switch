load "exception.rb"
load "instruction.rb"
load "table.rb"
load "parser.rb"
load "cli.rb"

settings = get_settings(ARGV)

begin
  code = Parser.create(read_table(settings[:input_file]), settings).generate
  output = settings[:output_file]
  if output.is_a? String
    output = File.open(output, "w")
  end
  output.puts(code)
rescue FixableException => e
  STDERR.puts "instrswitch: #{e}"
  exit 1
end
