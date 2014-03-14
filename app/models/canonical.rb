# Expressions Canonizer

#Вынесение чего-нить за скобку, дабы посчитать константы

require_relative 'tree.rb'
require_relative 'tree_builder.rb'
require_relative 'calculator.rb'

class Tree
  def op_sign sign
    if @data == sign
      @children.each do |child|
        if child.data == sign
          child.children.each do |childchild|
            @children << childchild
          end
          @children.delete(child)
        end
      end
    end
    unless @children.empty?
      @children.each do |child|
        child.op_sign(sign)
      end
    end
  end

  def open_brackets

    #puts "starting opening brackets for #{@data}"

    @children.each do |child|
      child.open_brackets 
    end

    #puts "opened all children brackets for #{@data}"

    if @data == '*'
      #puts "data == *, started real processing"
      new_tree = Tree.new('+')
      #puts 'ring before multiplier'
      @children[0].multiply_by(@children[1]).each do |new_child|
    #    puts 'new child'
    #    new_child.draw
        new_tree.add_child(new_child)
    #    puts 'new_tree'
    #    new_tree.draw
      end
    #  puts 'ring after multiplier'
      for i in 2...@children.size
    #    puts "in for; mul-ing #{@children[i]}"
        @children[i].multiply_by(new_tree).each do |new_child|
          new_tree.add_child(new_child)
        end
      end
      
      if new_tree.children.size > 1
        @data = new_tree.data
        @children.clear
        @children = new_tree.children
      end
    end
  end

  def multiply_by tree #принимает на вход два дерева с корнем + или const. Возвращает массив со всевозможными произведениями или самими деревьями, если перемножать нечего.
    #puts "in multiplier"
    #tree.draw
    #puts ""
    #self.draw
    #puts ""
    tree_array = []
    if @data == '+'
      @children.each do |child|
        if tree.data == '+' #(a+b)*(c+d)
    #      puts '(a+b)*(c+d)'
    #      print @children
    #      puts ""
            tree.children.each do |neig_child|
              sub_tree = Tree.new('*')
              sub_tree.add_child(child)
              sub_tree.add_child(neig_child)
    #          puts "subtree:"
    #          sub_tree.draw
              tree_array << sub_tree
            end
        else #(a+b)*c
     #     puts '(a+b)*c'
     #     puts 'child:'
     #     child.draw
          sub_tree = Tree.new('*')
          sub_tree.add_child(tree)
          sub_tree.add_child(child)
          tree_array << sub_tree
     #     puts 'out of cycle'
        end
      end
    else
      if tree.data == '+' #a*(b+c)
     #   puts 'a*(b+c)'
        tree.children.each do |neig_child|
          sub_tree = Tree.new('*')
          sub_tree.add_child(neig_child)
          sub_tree.add_child(self)
          tree_array << sub_tree
        end
      else #a*b
          #puts 'a*b'
          sub_tree = Tree.new('*')
          sub_tree.add_child(self)
          sub_tree.add_child(tree)
          tree_array << sub_tree
      end
    end
   # puts 'tree_array'
   # puts tree_array
    return tree_array
  end

  def sort_children
    @children.each{ |child| child.sort_children }
    if (@data == '*') || (@data == '+')
      @children.sort! do |x, y|
        if (x.children.size <=> y.children.size) == 0
          x.data <=> y.data
        else
          x.children.size <=> y.children.size
        end
      end
    end
  end

  def operate_binary_signs #- /
    @children.each { |child| child.operate_binary_signs }
    if @data == '-'
      #puts @children.size
      @data = '+'
      minus_tree = Tree.new('*')
      minus_tree.add_child(@children.pop)
      minus_tree.add_child(Tree.new('-1'))
      @children << minus_tree
      #puts @children.size
    elsif @data == '/'
      #puts @children.size
      @data = '*'
      div_tree = Tree.new('^')
      div_tree.add_child(@children.pop)
      div_tree.add_child(Tree.new('-1'))
      @children << div_tree
      #puts @children.size
    end
  end

  def canonize
    self.operate_binary_signs
    puts self.to_s
    self.op_sign('+')
    puts self.to_s
    self.op_sign('*')
    puts self.to_s
    self.draw
    #self.open_brackets
    puts self.to_s
    self.draw
    self.calculate
    puts self.to_s
    self.sort_children
    self.draw
  end
end
#tree = ['2', '*', 'pi', '*', 'sqrt', '(', 'd', ')'].parse_expression
#other_tree = ['2', '+', '2'].parse_expression
#tree.canonize
#other_tree.canonize

#puts 'parsed:'
#tree.draw
#puts "\n================"
#tree.operate_binary_signs
#other_tree.operate_binary_signs
#puts 'operated_binary_signs'
#tree.draw
#puts "\n================"
#tree.op_sign('+')
#tree.op_sign('*')
#puts 'signs operated:'
#tree.draw
#puts "\n================"
#puts '-------------------'
#tree.open_brackets
#puts '-------------------'
#puts 'brackets opened:'
#tree.draw
#puts "\n================"
#tree.calculate
#puts 'constants calculated'
#tree.draw
#puts "\n================"
#tree.sort_children
#puts 'children sorted'
#tree.draw

#puts tree.to_s
#puts other_tree.to_s
#puts tree == other_tree
