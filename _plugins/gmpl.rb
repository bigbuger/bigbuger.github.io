module Jekyll
  module GmplFilter

    @@keywords = [
      "set", "param", "var",
      "maximize", "minimize",
      "s.t.", "subject to", "subj to",
      
      "and", "else", "mod", "union",
      "by", "if", "not", "within",
      "cross", "in", "or",
      "diff", "inter", "symdiff",
      "div", "less", "then",
      
      "dimen", "default", "integer", "binary", "symbolic",
      "for", "check", "table", "IN", "OUT",
      
      "data", "end", "solve",
      
      "sum", "prod", "min", "max", "setof", "forall", "exists",
      
      "abs", "atan", "card", "ceil", "cos",
      "exp", "floor", "gmtime", "length",
      "log", "log10", "max", "min", "round",
      "sin", "sqrt", "str2time", "trunc",
      "Irand224", "Uniform01", "Uniform",
      "Normal01", "Normal",
      
      "substr", "time2str",
      
      "display", "printf",
    ]
    
    # @param [String]
    def gmpl(input)
      for w in @@keywords
        input.gsub!(/\b#{w}\b/, '<span class="k">\0</span>')
      end
      
      input
    end
  end
end

Liquid::Template.register_filter(Jekyll::GmplFilter)
