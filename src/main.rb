load "instruction.rb"
load "table.rb"
load "parser.rb"

puts Parser.new(read_table(STDIN), {}, 0).generate
