import java.util.concurrent.TimeUnit;
import java.io.FileWriter;
import java.io.File;
import java.util.Scanner;


int _width = 1000;
int _height = 1000;
int _size = 10;
boolean pause = true;
int counter;
int origin_x;
int origin_y;

int last_x_index;
int last_y_index;
boolean is_right_click;

Cell[][] grid;
boolean[][] saved_grid;
Linked_list selected_cells;
int[][] construct;

String[] lines;

File out_file;
FileWriter writer;

Scanner scan;

public void setup(){
  size(1000, 1000);
  selected_cells = new Linked_list();
  grid = new Cell[(_width/_size)][(_height/_size)];
  saved_grid = new boolean[(_width/_size)][(_height/_size)];
  lines = loadStrings("constructs.txt");
  scan = new Scanner(System.in);
  for(int i = 0; i < (grid.length); i ++)
  {
    for(int j = 0; j < (grid[i].length); j++)
    {
      grid[i][j] = new Cell(i, j);
    }
  
  }
  
  try
  {
    writer = new FileWriter(sketchPath() + "/constructs.txt",true);
  }
  catch(IOException error)
  {
    System.out.println("file = null.");
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
    is_right_click = false;
  }else if(mouseButton == RIGHT)
  {
    cell_under_mouse.is_alive = !cell_under_mouse.is_alive;
    cell_under_mouse.is_selected = !cell_under_mouse.is_selected;
    if(cell_under_mouse.is_selected)
    {
      selected_cells._add(cell_under_mouse);
    }
    else
    {
      selected_cells._remove(cell_under_mouse);
    }
    is_right_click = true;
  }
}

public void keyPressed(){
  if (Character.isDigit(key) && (key-48 <= (lines.length - 1)))
  {
    file_2_write(lines[key-48]);
  }
  switch(key)
  {
    case ' ':
      pause = !pause;
      break;
      
    case 'c':
      construct = constructor(origin_x, origin_y, selected_cells);
      break;
      
    case 'd':
      deconstruct(origin_x, origin_y, construct, grid.length, grid[0].length);
      break;
      
    case 's':
      for(int i = 0; i < (grid.length); i ++)
      {
        for(int j = 0; j < (grid[i].length); j++)
        {
          saved_grid[i][j] = grid[i][j].is_alive;
        }
      
      }
      break;
      
    case 'r':
      for(int i = 0; i < (grid.length); i ++)
      {
        for(int j = 0; j < (grid[i].length); j++)
        {
          grid[i][j].is_alive = saved_grid[i][j];
        }
      
      }
      break;
      
    case 'o':
      grid[origin_x][origin_y].is_origin = false;
      origin_x = (int) mouseX / _size;
      origin_y = (int) mouseY / _size;
      grid[origin_x][origin_y].is_origin = true;
      break;
      
    case 'p':
      for(int i = 0; i < construct.length; i++)
      {
        System.out.print("X: " + construct[i][0]);
        System.out.println("Y: " + construct[i][1]);
      }
      break;
    
    case DELETE:
      origin_x = 0;
      origin_y = 0;
      selected_cells = new Linked_list();
      for(int i = 0; i < (grid.length); i ++)
      {
        for(int j = 0; j < (grid[i].length); j++)
        {
          grid[i][j].is_alive = false;
          grid[i][j].is_selected = false;
          grid[i][j].is_origin = false;
          
        }
      
      }
    case 'w':
      int type_of_construct = 0;
      write_2_file(construct, type_of_construct);
      System.out.println("Transcript successful.");
      System.out.println("Please restart to update the saved constructs.");
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
    if(is_right_click)
    {
      cell_under_mouse.is_selected = !cell_under_mouse.is_selected;
      if(cell_under_mouse.is_selected)
      {
        selected_cells._add(cell_under_mouse);
      }
      else
      {
        selected_cells._remove(cell_under_mouse);
      }
    }
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

public int[][] constructor(int origin_x,int origin_y, Linked_list selected_cells)
{
  int [][] construct = new int[selected_cells.size][2];
  Node current_node = selected_cells.head;
  if (current_node == null)
  {
    System.out.println("No nodes selected.");
    return construct;
  }
  for (int i =0; i < construct.length; i++)
  {
    construct[i][0] = current_node.data[0] - origin_x;
    construct[i][1] = current_node.data[1] - origin_y;
    current_node = current_node.next;
  }
  return construct;
}

public void deconstruct(int origin_x,int origin_y, int[][] construct, int grid_height, int grid_width)
{
  for (int i =0; i < construct.length; i++)
  {
    int current_x = origin_x + construct[i][0];
    int current_y = origin_y + construct[i][1];
    if(exists(current_x, current_y, grid_height, grid_width))
    {
      grid[current_x][current_y].is_alive = true;
    }
  }
}
public void write_2_file(int[][] construct, int type)
{
  try
  {
    //header
    String ftype = String.format("%03d", type);
    String flength = String.format("%03d", construct.length);
    writer.write(ftype + flength);
    //coordinates
    for (int i =0; i < construct.length; i++)
    {
      writer.write(String.format("%03d", construct[i][0]) + String.format("%03d", construct[i][1]));
    }
    writer.write(System.lineSeparator());
  }
  catch(IOException error)
  {
    System.out.println("file = null.");
  }
  
  
}

public void file_2_write(String construct)
{
  int SIZE_OF_COORDINATES = 6;
  int size = Integer.valueOf(construct.substring(3, 6));
  for (int i = 6; i <= (size*SIZE_OF_COORDINATES); i+=SIZE_OF_COORDINATES)
  {
    int construct_x = Integer.valueOf(construct.substring(i, i+3)) + origin_x;
    int construct_y = Integer.valueOf(construct.substring(i+3, i+6)) + origin_y;
    
    grid[construct_x][construct_y].is_alive = true;
    
  }
}

public void exit()
{
  try
  {
    writer.close();
  }
  catch(IOException error)
  {
    System.out.println("file = null.");
  }
  
}
