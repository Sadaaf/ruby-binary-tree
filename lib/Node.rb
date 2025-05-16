class Node
  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
  end

  include Comparable
  def <=>(node)
    return nil unless node.is_a?(Node)
    @value <=> node.value
  end
end