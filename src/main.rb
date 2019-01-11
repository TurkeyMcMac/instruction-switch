load "instruction.rb"
load "table.rb"
load "parser.rb"

settings = {
  number_base: 16,
}

begin
  puts Parser.new(read_table("../instructions.tsv"), settings).generate
rescue AmbiguousCases => e
  STDERR.puts "instrswitch: Error: #{e}"
  exit 1
end
