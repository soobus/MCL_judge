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
      true_tree = $tokens.parse_expression
    rescue SystemStackError
      true_tree = Tree.new('N/A')
    ensure
      $tokens.clear
    end

    begin
      read(answer_to_check)
      check_tree = $tokens.parse_expression
    rescue SystemStackError
      check_tree = Tree.new('N|A')
    ensure
      $tokens.clear
    end

    begin
      true_tree.canonize
      true_tree.draw
      check_tree.canonize
      check_tree.draw
      return check_tree.to_s == true_tree.to_s

    rescue SystemStackError
      return false
    end
  end
end
