require "raylib-cr/rlgl"

module MapViewer
  def self.draw_grid(grid_size)
    RLGL.push_matrix
    RLGL.rotate_f(180, 0, 1, 0)
    RLGL.push_matrix
    RLGL.rotate_f(90, 1, 0, 0)
    RL.draw_grid(5000, grid_size)
    RLGL.pop_matrix
    RLGL.pop_matrix

    RLGL.push_matrix
    RLGL.rotate_f(-180, 0, 1, 0)
    RLGL.push_matrix
    RLGL.rotate_f(90, 1, 0, 0)
    RL.draw_grid(5000, grid_size)
    RLGL.pop_matrix
    RLGL.pop_matrix

    RLGL.push_matrix
    RLGL.rotate_f(90, 1, 0, 0)
    RL.draw_grid(5000, grid_size)
    RLGL.pop_matrix
  end
end
