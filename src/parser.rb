class Parser
  public

  def initialize(instructions, settings, parent_common)
    @settings = settings
    @common = Template::ALL.exclude(parent_common || Template::NONE)
    instructions.each do |instr|
      @common = instr.template.common(@common)
    end
    if instructions.length <= 1
      @children = [nil]
      return
    end
    if @common === Template::NONE
      throw AmbiguousCases.new
    end
    children = {}
    instructions.each do |instr|
      bits = instr.bits(@common).bits
      group = children[bits]
      if (group)
        group.push(instr)
      else
        children[bits] = [instr]
      end
    end
    @children = children.map { |bits, group|
      [bits, Parser.new(group, settings, @common)] }.to_h
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
    "switch (#{gen_switch_arg}){#{body}}"
  end

  def gen_switch_arg
    "#{gen_arg}&0x#{@common.bits.to_s(16)}"
  end

  def gen_child_cases
    @children.map { |bits, child|
      "case 0x#{(bits & @common.bits).to_s(16)}: #{child.send(:print_child)}; break;" }.join
  end

  def gen_return
    "return 0x#{@common.bits.to_s(16)}"
  end

  def gen_default
    "default:return -1;"
  end
end
