load "src/exception.rb"
load "src/instruction.rb"
load "src/table.rb"
load "src/parser.rb"

settings = {
  number_base: 16,
  do_instr: "DO_INSTR_",
  do_error: "DO_ERROR_",
}

begin
  puts Parser.create(read_table(ARGV[0]), settings).generate
rescue FixableException => e
  STDERR.puts "instrswitch: #{e}"
  exit 1
end
