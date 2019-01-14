def read_table(file)
  if file.is_a? String
    file = File.open(file)
  end
  lines = file.read.lines.map { |line| line.strip.split("\t") }
  raise FixableException.new("Empty instruction table.") if lines.length <= 1
  header = lines.shift
  n_columns = header.length
  name_col = format_col = nil
  header.each_with_index.each do |column, i|
    case column.strip.upcase
    when 'NAME'
      name_col = i
    when 'FORMAT'
      format_col = i
    end
  end
  raise FixableException.new("No 'name' column.") unless defined? name_col
  raise FixableException.new("No 'format' column.") unless defined? format_col
  size = 0
  lines.each do |cells|
    len = cells[format_col].length
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
    name: cells[name_col],
    format: cells[format_col],
    lineno: i + 2,
    size: size) }
end
