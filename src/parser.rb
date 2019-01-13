class Parser
  public

  def self.create(instructions, settings)
    instructions.permutation(2).each do |instrs|
      instr1 = instrs[0]
      instr2 = instrs[1]
      if (instr1.bits ^ instr2.bits) & (instr1.template & instr2.template) == 0
        raise FixableException.new([
          "Undecideable switch cases due to case #{instr2},",
          "indistinguishable from #{instr1}",
        ].join(' '))
      end
    end
    Parser.send(:new, instructions, settings)
  end

  def generate
    gen_func_wrapper(print_child)
  end

  private

  private_class_method :new

  def initialize(instructions, settings)
    @settings = settings
    if instructions.length <= 1
      @children = instructions
      return
    end
    @common = ~0
    instructions.each_with_index.each do |instr, i|
      @common &= instr.template
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
      [bits, Parser.send(:new, group, settings)] }.to_h
  end

  def gen_func_wrapper(body)
    do_instr = @settings[:do_instr]
    do_error = @settings[:do_error]
    return <<~C_CODE
      #if !defined(#{do_instr})
      #error macro #{do_instr} not defined
      #elif !defined(#{do_error})
      #error macro #{do_error} not defined
      #else
      #{body}
      #endif
    C_CODE
  end

  def print_child
    case @children.length
    when 0
      ""
    when 1
      gen_return
    else
      gen_switch("#{gen_child_cases} #{gen_default}")
    end
  end

  def gen_arg
    @settings[:argument]
  end

  def gen_switch(body)
    "switch(#{gen_switch_arg}){#{body}}"
  end

  def gen_switch_arg
    "#{gen_arg}&#{num(@common)}"
  end

  def gen_child_cases
    @children.map { |bits, child|
      "case #{num(bits & @common)}:#{child.send(:print_child)}" }.join
  end

  def gen_return
    instr = @children[0]
    params = instr.params
    "#{@settings[:do_instr]}(#{instr.name},(#{
      instr.params.map{ |p| gen_get_arg(p) }.join(',')
    }));break;"
  end

  def gen_default
    "default:#{@settings[:do_error]};"
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

  def gen_get_arg(param)
    instr = @children[0]
    push_top = 0
    arg = []
    param.reverse.each do |area|
      mask = (1 << area[:start]) - 1
      mask ^= (1 << area[:end]) - 1
      expr = "((#{gen_arg}&#{num(mask)})>>#{area[:end] - push_top})"
      push_top += area[:start] - area[:end]
      arg.push(expr)
    end
    arg.join('|')
  end
end
