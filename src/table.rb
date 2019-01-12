def read_table(path)
  lines = File.open(path).read.lines
  lines.shift
  lines.map! { |line|
    cells = line.split("\t")
    cells[1].strip!
    cells }
  size = 0
  lines.each do |cells|
    len = cells[1].length
    if len > 64
    end
    if size < len
      size = len
    end
  end
  size = case size
  when  1.. 8 then  8
  when  9..16 then 16
  when 17..32 then 32
  when 33..64 then 64
  else
    raise FixableException.new(
      "Invalid instruction size. Must be from 1 to 64 (inclusive.)")
  end
  lines.each_with_index.map { |cells, i| Instruction.new(
    name: cells[0],
    format: cells[1],
    lineno: i + 2,
    size: size) }
end
