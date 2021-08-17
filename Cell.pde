public class Cell {
  public int x;
  public int y;
  public int s;
  public boolean is_alive;
  public int population;
  public Cell(int x, int y){
    this.x = x;
    this.y = y;
    this.s = _size;
    this.is_alive = false;
    this.population = 0;
  }
  public void render(){
    stroke(255);
    if(is_alive)
    {
      fill(255);
    }else
    {
      fill(0);
    }
    rect(x * _size, y * _size, _size, _size);
  }
  public void update(){
    if (1 >= this.population || this.population >= 4)
    {
     this.is_alive = false;
    }else if(this.population == 3)
    {
      this.is_alive = true;
    }
  }
  
}
