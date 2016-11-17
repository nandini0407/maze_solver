class MazeSolver
  attr_reader :maze

  def initialize(maze)
    @maze = maze
    @queue = []
    @visited = []
    @previous = Hash.new()
  end

  def solve
    display(@maze)
    @queue << find_start
    begin
      next_position = @queue.shift
      @visited << next_position
      check_neighbors(next_position)
    end while get_element(next_position) == "S" || get_element(next_position) == " "
    return "Path not found" if get_element(next_position).nil?
    solved = solution(trace_path)
    puts "\n"
    display(solved)
  end

  private
  def find_start
    @maze.each_with_index do |line, i|
      line.each_with_index do |char, j|
        return [i, j] if char == "S"
      end
    end
    return nil
  end

  def find_end
    @maze.each_with_index do |line, i|
      line.each_with_index do |char, j|
        return [i, j] if char == "E"
      end
    end
    return nil
  end

  def get_neighbor_coordinates(coordinates)
    vertical = [[coordinates[0]-1, coordinates[1]], [coordinates[0]+1, coordinates[1]]]
    horizontal = [[coordinates[0], coordinates[1]-1], [coordinates[0], coordinates[1]+1]]
    neighbors = vertical + horizontal
    valid_neighbors = neighbors.select do |coords|
      coords[0].between?(0, @maze.length - 1) && coords[1].between?(0, @maze[0].length - 1)
    end
    valid_neighbors
  end

  def check_neighbors(coordinates)
    neighbors = get_neighbor_coordinates(coordinates)
    neighbors.each do |neighbor|
      if get_element(neighbor) == " " || get_element(neighbor) == "E"
        unless @visited.include?(neighbor) || @queue.include?(neighbor)
          @queue << neighbor
          @previous[neighbor] = coordinates
        end
      end
    end
  end

  def get_element(coordinates)
    @maze[coordinates[0]][coordinates[1]]
  end

  def trace_path
    path = [@previous[find_end]]
    begin
      next_pos = @previous[path[-1]]
      path << next_pos
    end while get_element(next_pos) != "S"
    path.reverse!
  end

  def solution(path)
    result = @maze.dup
    path.each do |coords|
      result[coords[0]][coords[1]] = "X" unless result[coords[0]][coords[1]] == "S"
    end
    result
  end

  def display(grid)
    grid.each { |line| puts line.join("")}
  end
end

maze_file = ARGV[0]
lines = []
File.foreach(maze_file) { |line| lines << line.chomp.split("")}
my_maze = MazeSolver.new(lines)
p my_maze.maze
my_maze.solve
