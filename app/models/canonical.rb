# Valery Nemychnikova Jan 26 2014

#Tree Canonizer

class Tree
  
  def canonize operate_sum=true, operate_mul=true, multiply_brackets=true, calculate=true
    self.calculate if calculate
    self.plus_to_minus 
    self.operate_sum if operate_sum
    self.operate_mul if operate_mul
    self.calculate if calculate
    self.operate_sum if operate_sum
    #self.multiply_brackets if multiply_brackets
    self.sort 
  end

  def multiply_brackets #here
    multipliers = [] #многомерный массив индексов перемножаемых вершин
    almost_result = [] #двумерный массив перемноженных вершин

    @nodes.each do |node|
      if node.data == '*'
        node.data = '+' #на этом месте теперь должен висеть +
        node.children.each do |child_id|
          multipliers << @nodes[child_id].children
        end
        almost_result = multipliers.generate_multiplied
        node.children.clear #
        almost_result.each do |set|
          self.add_node(node.id, '+')
          set.each do |addend_id|
            @nodes.last.add_son(addend_id)
            @nodes[addend_id].add_parent(@nodes.last.id)
          end
        end
      end
      multipliers = []
      almost_result = []
    end


  end

  def plus_to_minus 
    @nodes.each do |node|
      if node.data == '-' && node.children.size == 2
        node.data = '+' #меняем минус на плюс
        #puts 'changed + to -'
        self.add_node(node.id, '-') #добавляем ребенка-минус
        #puts 'have - neighbour' #здесь ошибка
        move_children(node.id, @nodes.last.id, [1]) #перенести детей вершины минус в вершину плюс
        #puts '- children moved to +'
        #puts 'added son'
      end
      #puts 'made one iteration'
    end
  end

  def move_children node1_id, node2_id, child_ids #заменяет детей вершины на детей первой вершины. айди вершин указаны в массиве (нумерация с нуля)
    children = []
    child_ids.each do |child_index|
      children << @nodes[node1_id].children[child_index]
      @nodes[node1_id].children[child_index] = nil
    end

    @nodes[node1_id].children.compact!.uniq!
    
    #puts 'after getting children from node1'
    #self.draw

    #print 'deti:', children, "\n"
    @nodes[node2_id].children = children
    #print "node 2 children must be same:", @nodes[node2_id].children
    children.each do |child_id| 
      @nodes[child_id].parent = node2_id
    end
  end

  def sort
    @nodes.each do |node|
      to_sort = get_children_data(node.id) #возвращает массив data из детей и кол-ва их детей
      to_sort.sort! do |x, y| 
        if (x[2] <=> y[2]) == 0
          if(x[1] <=> y[1]) == 0
            [-1, 1].sample
          else
            x[1] <=> y[1]
          end
        else
          x[2] <=> y[2]
        end
      end #встроенный сортировщик
      children = to_sort.map { |el| el.first }
      node.apply_children_data(children) #принимает отсортированный массив и располагает вершины по data в нужном порядке
    end
  end

  def get_children_data node_id
    ret_ar = []
    @nodes[node_id].children.each do |ch_id|
      ret_ar << [ch_id, @nodes[ch_id].data, @nodes[ch_id].children.size]
    end
    return ret_ar
  end

  def operate_sum
    @nodes.first.join("+", self)
  end

  def operate_mul
    @nodes.first.join("*", self)
  end

end

class Node

  def join operator, tree
    visited = Array.new(tree.nodes.size) { false }
    id = tree.nodes.index(self)

    if @children.empty?
      visited[id] = true
    else
      @children.each do |son_id|
        tree.nodes[son_id].join(operator, tree)
      end
          (@data == operator && tree.nodes[@parent].data == operator) ? tree.delete_node(id) : visited[id]= true
    end
  end 

  def apply_children_data children_id_array
    @children.clear
    @children = children_id_array
  end

  def <=> node #returns 1 if >
    if node.children.size < @children.size  
      #puts '<=> returned -1 because of size'
      return -1 
    elsif node.children.size > @children.size
      #puts '<=> returned 1 because of size'
      return 1
    else
      if node.data < @data
        #puts '<=> returned -1 because of data'
        return -1
      elsif node.data > @data
        #puts '<=> returned 1 because of data'
        return 1
      else
        #puts '<=> returned 0'
        return 0
      end
    end
  end

end

class Array #here
  def generate_multiplied muler=1
    result_array = []
    if self.size == 1
      self.flatten.each do |elem|
        result_array << [muler, elem]
      end
    else
      self.shift.each do |elem|
        generate_multiplied(elem)
      end
    end
    return result_array
  end
end
