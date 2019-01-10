class AmbiguousCases < RuntimeError
  def initialize(instr1, instr2)
    @str = "Undecideable switch cases due to case #{instr1}, indistinguishable from #{instr2}"
  end
  def to_s
    @str
  end
end

class Parser
  public

  def initialize(instructions, settings)
    @settings = settings
    @common = ~0
    instructions.each_with_index.each do |instr, i|
      @common &= instr.template
      if @common == 0
        other = instructions[0..i].find { |other|
          instr.template & other.template == 0 }
        raise AmbiguousCases.new(instr, other)
      end
    end
    instructions.permutation(2).each do |instrs|
      instr1 = instrs[0]
      instr2 = instrs[1]
      if (instr1.bits ^ instr2.bits) & (instr1.template & instr2.template) == 0
        raise AmbiguousCases.new(instr2, instr1)
      end
    end
    if instructions.length <= 1
      @children = [nil]
      return
    end
    children = {}
    instructions.each do |instr|
      bits = instr.bits & @common
      group = children[bits]
      if (group)
        group.push(instr)
      else
        children[bits] = [instr]
      end
    end
    @children = children.map { |bits, group|
      [bits, Parser.new(group, settings)] }.to_h
  end

  def generate
    gen_func_wrapper(print_child)
  end
  
  private

  def gen_func_wrapper(body)
    proto = @settings[:prototype] || "static int instrswitch(unsigned long #{gen_arg})"
    return "#{proto}{#{body}}"
  end

  def print_child
    @children.length <= 1 ? gen_return
      : gen_switch("#{gen_child_cases} #{gen_default}")
  end

  def gen_arg
    @settings[:function_argument] ? @settings[:function_argument] : "instr__"
  end

  def gen_switch(body)
    "switch (#{gen_switch_arg}){#{body}};"
  end

  def gen_switch_arg
    "#{gen_arg}&#{num(@common)}"
  end

  def gen_child_cases
    @children.map { |bits, child|
      "case #{num(bits & @common)}: #{child.send(:print_child)}" }.join
  end

  def gen_return
    "return #{num(@common)};"
  end

  def gen_default
    "default:return -1;"
  end

  def num(n)
    base = @settings[:number_base]
    base_prefix = case base
    when 2
      "0b"
    when 8
      "0"
    when 16
      "0x"
    else
      ""
    end
    "#{base_prefix}#{n.to_s(base)}"
  end
end
