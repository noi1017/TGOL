import java.util.concurrent.TimeUnit;

int _width = 400;
int _height = 400;
int _size = 10;
boolean pause = true;

Cell[][] grid;
boolean[][] saved_grid;

public void setup(){
  size(400, 400);
  grid = new Cell[(_width/_size)][(_height/_size)];
  saved_grid = new boolean[(_width/_size)][(_height/_size)];
  for(int i = 0; i < (grid.length); i ++)
  {
    for(int j = 0; j < (grid[i].length); j++)
    {
      grid[i][j] = new Cell(i, j);
    }
  
  }
}

public void draw(){
  background(255);
  if(!pause)
  {
    try
    {
      TimeUnit.MILLISECONDS.sleep(100);
    }
    catch(InterruptedException ex)
    {
      Thread.currentThread().interrupt();
    }
    for(int i = 0; i < (grid.length); i ++)
    {
      for(int j = 0; j < (grid[i].length); j++)
      {
        check(grid[i][j], grid[0].length, grid.length);
      }
    }
    for(int i = 0; i < (grid.length); i ++)
    {
      for(int j = 0; j < (grid[i].length); j++)
      {
        grid[i][j].update();
      }
    }
  }
  
  for(int i = 0; i < (grid.length); i ++)
  {
    for(int j = 0; j < (grid[i].length); j++)
    {
      grid[i][j].render();
    }
  }
}

public void mousePressed(){
  int mouse_index_x = (int) mouseX / _size;
  int mouse_index_y = (int) mouseY / _size;
  Cell cell_under_mouse = grid[mouse_index_x][mouse_index_y];
  cell_under_mouse.is_alive = !cell_under_mouse.is_alive;
  System.out.println(cell_under_mouse.population);
}

public void keyPressed(){
  if(key == ' ')
  {
    pause = !pause;
  }
  if(key == 's')
  {
    for(int i = 0; i < (grid.length); i ++)
    {
      for(int j = 0; j < (grid[i].length); j++)
      {
        saved_grid[i][j] = grid[i][j].is_alive;
      }
    
    }
  }
  if(key == 'r')
  {
    for(int i = 0; i < (grid.length); i ++)
    {
      for(int j = 0; j < (grid[i].length); j++)
      {
        grid[i][j].is_alive = saved_grid[i][j];
      }
    
    }
  }
}

public void check(Cell cell,int grid_height,int grid_width){
  int count = 0;
  for (int y = -1; y < 2; y++)
          {
              for (int x = -1; x < 2; x++)
              {
                if(x == 0 && y == 0)
                {
                  continue;
                }
                int arg_1 = cell.x + x;
                int arg_2 = cell.y + y;
                if (exists(arg_1, arg_2, grid_height, grid_width))
                {
                  if (grid[arg_1][arg_2].is_alive)
                  {
                    count++;
                  }
                }
              }
          }
  cell.population = count;
}
public boolean exists(int i, int j, int grid_height, int grid_width){
  if (i < 0 || j< 0 || i > (grid_height - 1) || j > (grid_width - 1))
  {
    return false;
  }
  return true;
}
