# Valery Nemychnikova sooobus@gmail.com
# Calculation methods, used by canonizer


class Tree
  def calculate node_id=0
    node = @nodes[node_id]
    if ['+', '-', '*', '/', 'sin', 'cos', 'tg', 'ctg', 'exp', 'sqrt', 'sqr'].include?(node.data) 
      ok = false
      node.children.each do |child_id|
        self.calculate(child_id)
        ok = true if @nodes[child_id].children.empty?
      end
      if ok
        self.calc(node)
      end
    else
      node.children.each do |child_id|
        self.calculate(child_id)
      end
    end
  end

  def calc node
    s = 0
    nodes_to_delete = []

    case node.data
    when 'sin'
        data = @nodes[node.children.first].data
        if data.is_number?
          s = Math.sin(data.to_f)
          nodes_to_delete << node.children.first
        end
    when 'cos'
        data = @nodes[node.children.first].data
        if data.is_number?
          s = Math.cos(data.to_f)
          nodes_to_delete << node.children.first
        end
    when 'tg'
        data = @nodes[node.children.first].data
        if data.is_number?
          s = Math.tan(data.to_f)
          nodes_to_delete << node.children.first
        end
    when 'ctg'
        data = @nodes[node.children.first].data
        if data.is_number?
          s = 1/Math.tan(data.to_f)
          nodes_to_delete << node.children.first
        end
    when 'exp'
        data = @nodes[node.children.first].data
        if data.is_number?
          s = Math.exp(data.to_f)
          nodes_to_delete << node.children.first
        end
    when 'sqr'
        data = @nodes[node.children.first].data
        if data.is_number?
          s = data.to_f ** 2
          nodes_to_delete << node.children.first
        end
    
    when 'sqrt'
        data = @nodes[node.children.first].data
        if data.is_number?
          s = Math.sqrt(data.to_f)
          nodes_to_delete << node.children.first
        end

    when '+'
      node.children.each do |child_id|
        data = @nodes[child_id].data
        if data.is_number?
          s+=data.to_f
          nodes_to_delete << child_id
        end
      end

    when '-'
     if @nodes[node.children.first].data.is_number? && @nodes[node.children.last].data.is_number?
        s = @nodes[node.children.first].data.to_f - @nodes[node.children.last].data.to_f
        nodes_to_delete << node.children
        nodes_to_delete.flatten!
     end


    when '*'
      s = 1
      node.children.each do |child_id|
        data = @nodes[child_id].data
        if data.is_number?
          s = s*data.to_f
          nodes_to_delete << child_id
        end
      end
      

    when '/'
      if @nodes[node.children.first].data.is_number? && @nodes[node.children.last].data.is_number?
        s = @nodes[node.children.first].data.to_f / @nodes[node.children.last].data.to_f
        nodes_to_delete << node.children
        nodes_to_delete.flatten!
      end
    end

    if !nodes_to_delete.empty?
      if (node.children - nodes_to_delete).empty?
        node.data = (s.to_i.to_f - s == 0 ? s.to_i.to_s : s.to_s)
        node.children.each do |node_id|
          delete_node(node_id)
        end
        node.children.clear
      else
        @nodes[nodes_to_delete.shift].data = (s.to_i.to_f - s == 0 ? s.to_i.to_s : s.to_s)
        nodes_to_delete.each do |node_id|
          delete_node(node_id)
        end
        node.children = node.children - nodes_to_delete
      end
    end
  end
end
