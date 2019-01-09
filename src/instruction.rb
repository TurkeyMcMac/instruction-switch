class Instruction
  def initialize(str)
    @template = 0
    @bits = 0
    str.chars.each_with_index.each do |char, i|
      bit = 1 << (7 - i)
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
end
