load "instruction.rb"
load "table.rb"
load "parser.rb"

begin
  puts Parser.new(read_table("../instructions.tsv"), {}).generate
rescue AmbiguousCases => e
  STDERR.puts "instrswitch: Error: #{e}"
  exit 1
end
