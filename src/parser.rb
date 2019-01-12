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
      @children = instructions
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
    do_instr = @settings[:do_instr]
    do_error = @settings[:do_error]
    return <<~C_CODE
      #if !defined(#{do_instr})
      #error macro #{do_instr} not defined
      #elif !defined(#{do_error})
      #error macro #{do_error} not defined
      #else
      #{proto}{#{body}}
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
    @settings[:function_argument] ? @settings[:function_argument] : "instr__"
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
    }));return;"
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
    "parm"
  end
end
