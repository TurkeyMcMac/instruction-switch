class Instruction
  def initialize(name, format, lineno)
    @name = name
    @format = format
    @lineno = lineno
    @template = 0
    @bits = 0
    format.chars.each_with_index.each do |char, i|
      bit = 1 << (15 - i)
      case char
      when '1'
        @bits |= bit
        @template |= bit
      when '0'
        @template |= bit
      end
    end
  end

  def template
    @template
  end

  def bits
    @bits
  end

  def to_s
    "<Instruction '#{@name}' {#{@format}} (line #{@lineno})>"
  end
end
