# Valery Nemychnikova sooobus@gmail.com

# The Tree Builder by Input Array

=begin
<expr> ::= <minus-expr> [+ <expr>]
<minus-expr> ::= <addend> [- <minus-expr>]
<addend> ::= <pow> <mult-op> <addend>  
<pow> ::= <primary> [^ <pow>]
<primary> ::= [-] (<number> | <identifier> | <function-call> | ‘(‘ <expr> ‘)’)
<function-call> ::= <identifier> ‘(‘ <expr> ‘)’ 
=end

class Array
  def parse_expression
    #print self
    brackets = 0
    delimiter = nil
    for i in 0...self.size
      case self[i]
      when '('
        brackets+=1
      when ')'
        brackets-=1
      when '+'
     #   puts 'met +'
        if brackets == 0
          delimiter = i
          break
        end
      end
    end
    
    if delimiter == nil
      return self.parse_minus_expression
    else
      tree = Tree.new(self[delimiter])

      tree.add_child(self[0...delimiter].parse_minus_expression) if not self[0...delimiter].empty?
      tree.add_child(self[delimiter+1..-1].parse_expression)

      #$tree.draw
    end
    #tree.draw
   # puts 'parse_expression is going to return:'
    #print tree
    #tree.draw
    return tree
  end

  def parse_minus_expression
   # print self
    brackets = 0
    delimiter = nil
    for i in 0...self.size
      case self[i]
      when '('
        brackets+=1
      when ')'
        brackets-=1
      when '-'
        if brackets == 0
          delimiter = i
          break
        end
      end
    end
    
    if delimiter == nil
      return self.parse_addend
    else
      tree = Tree.new(self[delimiter])

      tree.add_child(self[0...delimiter].parse_addend) if not self[0...delimiter].empty?
      tree.add_child(self[delimiter+1..-1].parse_minus_expression)

      #puts "added node #{parent}, #{self[delimiter]}"
      #$tree.draw
    end
    #puts "parse_minus is going to return"
    #print tree
    #tree.draw
    return tree
  end
  def parse_addend
   # print self
    brackets = 0
    delimiter = nil
    for i in 0...self.size
      case self[i]
      when '('
        brackets+=1
      when ')'
        brackets-=1
      when '*', '/'
        if brackets == 0
          delimiter = i
          break
        end
      end
    end
     
    if delimiter == nil
      return self.parse_pow
    else
      tree = Tree.new(self[delimiter])
      tree.add_child(self[0...delimiter].parse_pow)
      tree.add_child(self[delimiter+1..-1].parse_addend)
    end
    #puts "parse_addend is going to return"
    #print tree
    #tree.draw
    return tree
  end
  
  def parse_pow
    #print self
    brackets = 0
    delimiter = nil
    for i in 0...self.size
        case self[i]
        when '('
          brackets+=1
        when ')'
          brackets-=1
        when '^'
          if brackets == 0
            delimiter = i
          break
        end
      end
    end
     
    if delimiter == nil
      return self.parse_primary
    else
      tree = Tree.new(self[delimiter])
      tree.add_child(self[0...delimiter].parse_primary)
      tree.add_child(self[delimiter+1..-1].parse_pow)
    end
    #puts "parse_pow is going to return"
    #print tree
    #tree.draw
    return tree
  end


  def parse_primary
    #puts 'primary'
    #print self
    if self.first == '-'
      self.shift
      tree = Tree.new('-')
      tree.add_child(self.parse_primary)
    else
      if self.first == '(' && self.last == ')'
        self.pop
        self.shift
        return self.parse_expression
      else
        if self.size == 1
          tree = Tree.new(self.first)
     #     puts "added node #{self.first}"
          #$tree.draw
        else
      #    puts 'going to parse f call'
          return self.parse_function_call
        end
      end
    end
   # puts "parse_primary is going to return"
   # print tree
    #tree.draw
    return tree
  end

  def parse_function_call
   # print self
    tree = Tree.new(self.shift)
    #print tree.data
    self.shift
    self.pop
    #print self
    tree.add_child(self.parse_expression)
   # puts "parse function call is going to return"
    #print tree
   # tree.draw
    return tree
  end
end

#tree = ['1', '+', '2'].parse_expression
#tree.draw
