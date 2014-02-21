#Valery Nemychnikova sooobus@gmail.com

#Tree Keeper for Expression Parser

class Tree
  
  attr_accessor :nodes
  def initialize data = nil #tree initialization makes a new Tree with a root with data == nil by default
    @nodes_num = 0
    @nodes = [Node.new(nil, data, 0)]
  end

  def add_node parent_id, data
    node = Node.new(parent_id, data, @nodes.size)
    @nodes_num+=1
    @nodes << node
    @nodes[parent_id].add_son(node.id)
    @nodes.last.add_parent(parent_id)
    node
  end
 
  def delete_node id
    node = @nodes[id]
    @nodes[node.parent].children.delete(id) #удаляем у родителя ребенка
    node.children.each do |child|
      @nodes[child].parent = node.parent #заменяем у детей родителя на родителя вершины
      @nodes[node.parent].children << child #добавляем родителю детей вершины
    end
    @nodes[id].parent = 0; @nodes[id].children.clear; @nodes[id].data = nil #стираем вершину
  end

  def swap_nodes node1_index, node2_index #only for one level ATTENTION NO CHECK!

    node1 = @nodes[node1_index]
    node2 = @nodes[node2_index]

    node1.children.each do |son_index|
      @nodes[son_index].parent = node2_index
    end

    node2.children.each do |son_index|
      @nodes[son_index].parent = node1_index
    end

    @nodes[node1_index] = node2
    @nodes[node2_index] = node1 
  end

  def == tree #tree comparing: self tree is compared to an argument tree
   return (self.to_s == tree.to_s)
  end

  def draw
    @nodes.each do |node|
      puts "#{node.data} : id : #{node.id} : parents : #{node.parent} : children : #{node.children.join(", ")}" 
    end
  end

  def to_s
    @nodes[1].show(@nodes)
  end
  
end

class Node

  attr_accessor :parent, :data, :children, :id
  def initialize parent_id, data, t_size #id 
    @parent = parent_id
    @data = data
    @children = []
    @id = t_size 
  end
  
  def add_son son_id
    @children << son_id
  end

  def add_parent parent_id
    @parent = parent_id
  end

  def == node
    return false if (@parent != node.parent) || (@data != node.data) 
    return true
  end

  def show nodes
      if @children.empty?
        return @data
      elsif @children.size == 1
        return '(' + @data + nodes[@children.first].show(nodes) + ')'
      else
        string = '(' + nodes[@children.first].show(nodes) + @data
        for i in 1...@children.size-1
          string += (nodes[@children[i]].show(nodes) + @data)
        end
        string += (nodes[@children.last].show(nodes) + ')')
      end
  end 
end
