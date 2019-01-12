class Instruction
  def initialize(name, format, lineno)
    @name = name
    @format = format
    @lineno = lineno
    @template = 0
    @bits = 0
    @params = []
    params = {}
    param_name = nil
    format.chars.each_with_index.each do |char, progress|
      idx = 15 - progress
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
            start: idx,
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

  def template
    @template
  end

  def bits
    @bits
  end

  def to_s
    "<Instruction '#{@name}' {#{@format}} (line #{@lineno})>"
  end

  def params
    @params
  end

  def name
    @name
  end
end
