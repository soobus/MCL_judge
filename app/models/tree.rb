# NEW Tree Keeper for Expression Parser

class Tree
  attr_accessor :data, :children
  def initialize data='N/A'
    @data = data
    @children = []
  end

  def add_child tree
    @children << tree
  end

  def draw
    print "\n" + @data + ':'
    @children.each{ |child| print ' ' + child.data}
    @children.each{ |child| child.draw }
    #print "\n"
  end

  def to_s
    #print @children
    if @children.empty?
      #puts 'empty!'
      return @data
    elsif @children.size == 1
      return @data + '(' + @children.first.data + ')'
    else
      #puts 'not empty!'
      string = "("
      string << @children.first.to_s
      @children[1..-1].each do |child|
        string << @data
        string << child.to_s
      end
      string << ')'
      return string
    end
  end

  def == tree
    return (self.to_s == tree.to_s)
  end
end

#tree = Tree.new('+')
#tree.add_child('x')
#tree.add_child('y')
#tree.draw


