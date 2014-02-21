class Task < ActiveRecord::Base
  attr_accessible :answer, :data, :id, :img_url, :title, :user_answer

  def check_answer
    require 'stringio' #gem that allows operating with string like with IO
    require_relative 'tree.rb' #Tree class keeper
    require_relative 'data.rb' #data keeper
    require_relative 'lexer.rb' #lexem array builder
    require_relative 'tree_builder.rb' #turns array into tree
    require_relative 'calculator.rb' #method for counting constant, used by canonizer
    require_relative 'canonical.rb' #method for tree canonization 
    
    begin
      true_answer = StringIO.new(self.answer + '#')
      answer_to_check = StringIO.new(self.user_answer + '#')
      read(true_answer)
      $tokens.parse_expression
    rescue SystemStackError
      $tree = Tree.new
    ensure
      $tokens.clear
      $tree1 = $tree
      $tree = Tree.new
    end

    begin
      read(answer_to_check)
      $tokens.parse_expression
    rescue SystemStackError
      $tree = Tree.new
    ensure
      $tokens.clear
      $tree2 = $tree
      $tree = Tree.new
    end

    begin
      $tree1.canonize
      $tree2.canonize
      return $tree1 == $tree2
    rescue SystemStackError
      return false
    end
  end
end
