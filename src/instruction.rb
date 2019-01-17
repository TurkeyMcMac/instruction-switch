class Instruction
  attr_reader :template, :bits, :params, :name

  def initialize(name:, format:, lineno:, size:)
    @name = name
    @format = format
    @lineno = lineno
    @template = 0
    @bits = 0
    @params = []
    params = {}
    param_name = nil
    format.chars.each_with_index.each do |char, progress|
      idx = size - 1 - progress
      bit = 1 << idx
      if char == param_name
        params[param_name].last[:end] = idx
      else
        param_name = nil
        case char
        when '1'
          @bits |= bit
          @template |= bit
        when '0'
          @template |= bit
        when '_', ' '
          # Do nothing
        else
          new_param = {
            start: idx + 1,
            end: idx,
          }
          param_name = char
          if params[param_name]
            params[param_name].push(new_param)
          else
            params[param_name] = [new_param]
            @params.push(param_name)
          end
        end
      end
    end
    @params.map! { |name| params[name] }
  end

  def to_s
    "<Instruction '#{@name}' {#{@format}} (line #{@lineno})>"
  end
end
