# Valery Nemychnikova sooobus@gmail.com

# The Tree Builder by Input Array

=begin
<expr> ::= <addend> <sum-op> <expr>
<addend> ::= <primary> <mult-op> <addend>  
<primary> ::= [-] (<number> | <identifier> | <function-call> | ‘(‘ <expr> ‘)’)
<function-call> ::= <identifier> ‘(‘ <expr> ‘)’ 
=end


class Array
  def parse_expression parent=0
    #puts "parsing #{self} : expr"
    brackets = 0
    delimiter = nil
    for i in 0...self.size
      case self[i]
      when '('
        brackets+=1
      when ')'
        brackets-=1
      when '+', '-'
        if brackets == 0
          delimiter = i
          break
        end
      end
    end
    
    if delimiter == nil
      self.parse_addend(parent)
    else
      $tree.add_node(parent, self[delimiter])
      just_added_node = $tree.nodes.size-1
      #puts "added node #{parent}, #{self[delimiter]}"
      #$tree.draw
      self[0...delimiter].parse_addend(just_added_node) if not self[0...delimiter].empty?
      self[delimiter+1..-1].parse_expression(just_added_node)
    end
  end

  def parse_addend parent
      #puts "parsing #{self}: addend"
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
        self.parse_primary(parent)
      else
        $tree.add_node(parent, self[delimiter])
        #puts "added node #{parent}, #{self[delimiter]}"
        #$tree.draw
        just_added_node = $tree.nodes.size-1
        self[0...delimiter].parse_primary(just_added_node)
        self[delimiter+1..-1].parse_addend(just_added_node)
      end  
  end

  def parse_primary parent
    #puts "parsing #{self}: primary"
    if self.first == '-'
      self.shift
      self.parse_primary(parent)
    else
      if self.first == '(' && self.last == ')'
        self.pop
        self.shift
        self.parse_expression(parent)
      else
        if self.size == 1
          $tree.add_node(parent, self.first)
          #puts "added node #{parent} #{self.first}"
          #$tree.draw
        else
          parse_function_call(parent)
        end
      end
    end
  end

  def parse_function_call parent
    #puts "parsing #{self}: func-call"
    $tree.add_node(parent, self.shift)
    #puts "added node #{parent} self.shift"
    #$tree.draw
    self.shift
    self.pop
    self.parse_expression($tree.nodes.size-1)
  end
end

