load "instruction.rb"
load "table.rb"
load "parser.rb"

settings = {
  number_base: 16,
  do_instr: "DO_INSTR_",
  do_error: "DO_ERROR_",
}

begin
  puts Parser.create(read_table("../instructions.tsv"), settings).generate
rescue AmbiguousCases => e
  STDERR.puts "instrswitch: Error: #{e}"
  exit 1
end
