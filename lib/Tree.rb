require_relative "Node"
class Tree
  attr_accessor :root
    def initialize(value)
      arr = sort_array(value)
      p arr
      @root = build_tree(arr)
    end

    #Merges two array from small to large
    def merge(left, right)
      result = []
      while left.any? && right.any?
        if left.first < right.first
          value = left.shift
          result << value unless result.last == value
        else
          value = right.shift
          result << value  unless result.last == value
        end
      end
      (left+right).each do |element|
        result << element unless element == result.last
      end
      return result
    end
    
    #prints the tree
    def pretty_print(node = @root, prefix = '', is_left = true)
      pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
      puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
      pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end   

    # Helps sort arrays
    def sort_array(arr)
      return arr if arr.length == 1
      left = sort_array(arr[0...arr.length/2])
      right = sort_array(arr[arr.length/2..arr.length])
      return merge(left,right)
    end

    # Builds the binary tree
    def build_tree(arr)
      return nil if arr.empty?
      middle_index = arr.length/2
      root = Node.new(arr[middle_index])
      root.left = build_tree(arr[0...middle_index])
      root.right = build_tree(arr[middle_index+1 .. -1])
      return root
    end

    # Inserts the value
    def insert(value)
      new_node = Node.new(value)
      return @root = new_node if @root.nil?
      current = @root
      loop do
        if new_node < current
          if current.left
            current = current.left
          else
            current.left = new_node
            break
          end
        elsif new_node > current
          if current.right
            current = current.right
          else
            current.right = new_node
            break
          end
        else
          break # Duplicate value — do nothing
        end
      end
    end
    
    # Delete a specific node
    def delete(value)
      new_node = Node.new(value)
      current = @root
      last_node = @root
      loop do
        if current < new_node
          break if current.right.nil?
          last_node = current
          current = current.right
        elsif current > new_node
          break if current.left.nil?
          last_node = current
          current = current.left
        else
          target_node_on_left = true if !last_node.left.nil? && last_node.left == current 
          left_child = current.left
          left_subtree = current.left
          right_subtree = current.right
          right_child = current.right
          leaf_node = current
          if !left_child.nil? && !right_child.nil?
            loop do
              if !right_child.left.nil?
                leaf_node = right_child
                right_child = right_child.left
              else
                if @root == current
                  @root = right_child
                elsif target_node_on_left
                  last_node.left = right_child
                else
                  last_node.right = right_child
                end
                leaf_node.left = nil
                # Problem is Down below
                right_child.right = right_subtree
                right_child.left = left_subtree
                # p current.value
                break
              end
            end

          elsif !left_child.nil? || !right_child.nil?
            if target_node_on_left
              last_node.left = left_child || right_child
            else
              last_node.right = left_child || right_child
            end
            
          else
            if target_node_on_left
              last_node.left = nil
            else
              last_node.right = nil
            end
          end
          return current
        end
      end
    end

    def find(value)
      current_node = @root
      loop do
        return current_node if current_node.value == value
        if current_node.value > value
          return nil if current_node.left.nil?
          current_node = current_node.left
        else
          return nil if current_node.right.nil?
          current_node = current_node.right
        end
      end
    end

    def level_order_using_loops
      return [] if @root.nil?
      queue = [@root]
      result = []
      #Using Loops
      while !queue.empty?
        node = queue.shift
        if block_given?
          yield node.value
        else
          result << node.value
        end
        queue << node.left if !node.left.nil?
        queue << node.right if !node.right.nil?
      end
      return result unless block_given?
    end

    def height(root)
      return 0 if root.nil?
      [height(root.left), height(root.right)].max + 1
    end

    def level_order_recursion(root, result=[])
      return [] if root.nil?
      result = []
      height = height(root)
      (0...height).each do |level|
        collect_level(root, level, result)
      end
      return result
    end

    def collect_level(node, level, result)
      if level == 0
        result << node.value
      else
        collect_level(node.left, level-1, result) if !node.left.nil?
        collect_level(node.right, level-1, result) if !node.right.nil?
      end
    end
end

tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
tree.delete(4)
tree.pretty_print
p tree.find(5)
# No Blocks passed
p tree.level_order_using_loops
# Passing a block
tree.level_order_using_loops do |value|
  puts "Visited #{value}"
end
p tree.level_order_recursion(tree.root)
