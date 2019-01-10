def read_table(path)
  lines = File.open(path).read.lines
  lines.shift
  lines.each_with_index.map { |line, i|
    cells = line.split("\t")
    name, format = cells[0], cells[1].strip
    Instruction.new(name, format, i + 1)}
end
