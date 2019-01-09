load "template.rb"
load "instruction.rb"
load "table.rb"
load "parser.rb"

puts Parser.new(read_table(STDIN), {}, Template::NONE).generate
