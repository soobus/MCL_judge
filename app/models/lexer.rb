#Valery Nemychnikova sooobus@gmail.com

#Lexical Analysis

def read stringio
  lexem = ""
  until stringio.eof
    char = stringio.getc
    new_lexem = lexem + char
    if new_lexem.is_token?
      lexem = new_lexem
    else
      $tokens << lexem
      lexem = char
    end
  end
  #print $tokens
end

class String
  def is_token?
=begin
<token> ::= <number> | <operator> | <bracket> | <identifier> 
<number> ::= <digit>{<digit>}[.<digit>{<digit>}]
<operator> ::=  * | / | + | -
<bracket> ::= ( | )
<identifier> ::= <letter>{<letter>}
<digit> ::= 1|2|3|4|5|6|7|8|9|0
<letter> ::= a|b|c|d|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z
=end
    self.is_number? || self.is_operator? || self.is_bracket? || self.is_identifier?
  end

  def is_number?
    chars = self.split("")
    return false if not chars.shift.is_digit? 
    until chars.empty? 
      c = chars.shift
      if c.is_digit?
      elsif c == "."
        break
      else
        return false
      end
    end

    until chars.empty? 
      return false if not chars.shift.is_digit?
    end

    return true
  end

  def is_operator?
    ['+', '-', '*', '/'].include?(self)
  end

  def is_bracket?
    ['(', ')'].include?(self)
  end

  def is_identifier?
    chars = self.split("")
    return false if not chars.shift.is_letter?
    until chars.empty?
      return false if not chars.shift.is_letter?
    end
    return true
  end

  def is_digit?
    ['0','1','2','3','4','5','6','7','8','9'].include?(self)    
  end

  def is_letter?
    ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'].include?(self)
  end

end
        

