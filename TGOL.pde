import java.util.concurrent.TimeUnit;

int _width = 1000;
int _height = 1000;
int _size = 10;
boolean pause = true;
int counter;
int origin_x;
int origin_y;

int last_x_index;
int last_y_index;

Cell[][] grid;
boolean[][] saved_grid;

public void setup(){
  size(1000, 1000);
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
  last_x_index = (int) mouseX / _size;
  last_y_index = (int) mouseY / _size;
  Cell cell_under_mouse = grid[last_x_index][last_y_index];
  if (mouseButton == LEFT)
  {
    cell_under_mouse.is_alive = !cell_under_mouse.is_alive;
  }else if(mouseButton == RIGHT)
  {
    cell_under_mouse.is_selected = !cell_under_mouse.is_selected;
    counter++;
  }
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
  if(key == 'o')
  {
    grid[origin_x][origin_y].is_origin = false;
    origin_x = (int) mouseX / _size;
    origin_y = (int) mouseY / _size;
    grid[origin_x][origin_y].is_origin = true;
  }
}
public void mouseDragged(){
  int current_x_index = (int) mouseX / _size;
  int current_y_index = (int) mouseY / _size;
  if (exists(current_x_index, current_y_index,grid[0].length, grid.length))
  if ((current_x_index != last_x_index) || (current_y_index != last_y_index))
  {
    Cell cell_under_mouse = grid[current_x_index][current_y_index];
    cell_under_mouse.is_alive = !cell_under_mouse.is_alive;
    last_x_index = current_x_index;
    last_y_index = current_y_index;
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
