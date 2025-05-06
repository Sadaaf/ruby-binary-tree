class Node
  attr_accessor :value, :left_child, right_child
  include Comparable
  def <=>(node)
    @value <=> node.value
  end
end