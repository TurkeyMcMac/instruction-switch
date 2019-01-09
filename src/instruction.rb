class Instruction
  def initialize(str)
    template_bits = 0
    @bits = 0
    str.chars.each_with_index.each do |char, i|
      bit = 1 << (7 - i)
      case char
      when '1'
        @bits |= bit
        template_bits |= bit
      when '0'
        template_bits |= bit
      end
    end
    @template = Template.new(template_bits)
  end

  def template
    @template
  end

  def bits(mask)
    Template.new(@bits & mask.bits)
  end
end
