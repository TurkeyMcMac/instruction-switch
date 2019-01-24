require "optparse"

def get_settings(argv)
  version = [0,0,4]

  settings = {
    input_file: STDIN,
    output_file: STDOUT,
    number_base: 16,
    do_instr: "DO_INSTR_",
    do_error: "DO_ERROR_",
    argument: "INSTR_",
  }

  OptionParser.new do |opts|
    opts.banner = "Usage: instrswitch [options]"
    opts.version = version

    opts.on("-i", "--input FILE",
            "Read the instruction table from FILE. The default is stdin."
    ) do |file|
      settings[:input_file] = file
    end

    opts.on("-o", "--output FILE",
            "Write the instruction table to FILE. The default is stdout."
    ) do |file|
      settings[:output_file] = file
    end

    opts.on("--base N", ["2", "8", "10", "16"],
            "Print numbers in base N. The valid values are 2, 8, 10, and 16.",
            "Keep in mind that base 2 number literals are not standard in C.",
            "The default value is 16."
    ) do |base|
      settings[:number_base] = base.to_i
    end

    opts.on("--do-instr SYMBOL",
            "Set the name of the macro called when the case is determined",
            "to SYMBOL. There are two arguments: the name of the instruction",
            "as a symbol and the arguments wrapped in parentheses separated by",
            "commas. The default is 'DO_INSTR_'."
    ) do |symbol|
      settings[:do_instr] = symbol
    end

    opts.on("--do-error SYMBOL",
            "Set the name of the macro called when no case matches to SYMBOL.",
            "The macro takes no arguments. The default is 'DO_ERROR_'."
    ) do |symbol|
      settings[:do_error] = symbol
    end

    opts.on("--argument SYMBOL",
            "Set the symbol used for the argument being examined. The default",
            "is 'INSTR_'."
    ) do |symbol|
      settings[:argument] = symbol
    end

    opts.on("--instr-prefix PREFIX",
            "Prefix the argument list to each instruction call with PREFIX."
    ) do |prefix|
      settings[:instr_prefix] = prefix
    end

    opts.on_tail("-h", "--help", "Print this help information and exit.") do
      puts opts
      exit
    end

    opts.on_tail("--version", "Print the version and exit.") do
      puts opts.ver
      exit
    end
  end.parse!(argv)

  settings
end
