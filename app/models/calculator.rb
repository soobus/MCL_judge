#Calculation methods

=begin
File.open('allowed_operations', 'r') do |file| #allowed_operations
  $allowed_op = file.read.split("\n")  
end
=end

$allowed_op = ["+", "-", "*", "/", "sin", "cos", "tg", "ctg", "exp", "sqrt", "cbrt", "^", "pi", "e"]  

class Tree
  
  def calculate
    #print "current: #{@data}\n"
    @children.each do |child| #рекурсивно сходили во всех детей
        child.calculate
    end
    #обработали вершину: если подходит, сделали операции, может и схлопнули
    if $allowed_op.include?(@data) #подходящая операция
      self.calc_operation(@data)
    end
  end

  def calc_operation sign #все дети гарантированно посещены
    collector = []

    #print "size: #{@children.size} \n"
    #print "\n"

    @children.each do |child|
      #puts "child: #{child.data}"
      if not (child.data =~ /\d/).nil?
        collector << child
        puts "added #{child.data}"
      end
    end

    unless collector.empty?
      puts "@children.size: #{@children.size}"
      @children-=collector
      puts "@children.size: #{@children.size}"

      collector.map!{ |elem| elem.data.to_f }

    #puts "new size: #{@children.size}"
    print 'collector: '
    print collector

      sum = collector.count(@data)
    
      if @children.empty?
        @data = sum if not sum.nil?
      else
        self.add_child(Tree.new(sum)) if not sum.nil?
      end
    end
  end
end

class Array
  def count op_sign
    case op_sign
    when '+'
      res = self.inject{|sum, i| sum+=i}.to_s
      return res[-2..-1] == '.0' ? res[0...-2] : res
    when '*'
      res = self.inject{|sum, i| sum = sum * i}.to_s
      return res[-2..-1] == '.0' ? res[0...-2] : res
    when '-'
      return (-self[0]).to_s
      return res[-2..-1] == '.0' ? res[0...-2] : res
    when '/'
      return ((self.first)/(self.last)).to_s
      return res[-2..-1] == '.0' ? res[0...-2] : res
    when 'sin'
      return Math.sin(self[0]).to_s
      return res[-2..-1] == '.0' ? res[0...-2] : res
    when 'cos'
      return Math.cos(self[0]).to_s
      return res[-2..-1] == '.0' ? res[0...-2] : res
    when 'tg'
      return Math.tan(self[0]).to_s
      return res[-2..-1] == '.0' ? res[0...-2] : res
    when 'ctg'
      return (1/Math.tan(self[0])).to_s
      return res[-2..-1] == '.0' ? res[0...-2] : res
    when 'exp'
      return ((Math::E)**(self[0])).to_s
      return res[-2..-1] == '.0' ? res[0...-2] : res
    when 'sqrt'
      return Math.sqrt(self[0]).to_s
      return res[-2..-1] == '.0' ? res[0...-2] : res
    when 'cbrt'
      return Math.cbrt(self[0]).to_s
      return res[-2..-1] == '.0' ? res[0...-2] : res
    when '^'
      return ((self.first)**(self.last)).to_s
      return res[-2..-1] == '.0' ? res[0...-2] : res
    when 'pi'
      return Math::PI.to_s
      return res[-2..-1] == '.0' ? res[0...-2] : res
    when 'e'
      return Math::E.to_s
      return res[-2..-1] == '.0' ? res[0...-2] : res
    end
    if collector.size == 1
      return collector.first.to_s
    else
      return nil
    end
  end
end
