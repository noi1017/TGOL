import java.util.Arrays;

public class Linked_list
{
  Node head;
  Node tail;
  
  int size = 0;
  
  public Linked_list()
  {
    this.head = null;
    this.tail = null;
  }
  public void _add(Cell new_node)
  {
    int[] coordinates = {new_node.x, new_node.y};
    this._add(coordinates);
    size++;
  }
  
  public void _add(int[] new_node)
  {
    
    Node new_element = new Node(new_node);
    if (head == null)
    {
      head = new_element;
      tail = new_element;
    }
    else
    {
      tail.next = new_element;
      tail = new_element;
    }
  }
  
  public void _remove(Cell old_node)
  {
    int[] coordinates = {old_node.x, old_node.y};
    this._remove(coordinates);
  }
  
  public void _remove(int[] old_node)
  {
    if(head == null)
    {
      return;
    }
    Node previous_node = head;
    Node current_node = previous_node.next;
    if(Arrays.equals(previous_node.data, old_node))
    {
      head = current_node;
      size--;
      return;
    }
    while(current_node != null)
    {
      if(Arrays.equals(current_node.data, old_node))
      {
        if(current_node == tail)
        {
          tail = previous_node;
          previous_node.next = null;
          size--;
          return;
        }
        previous_node.next = current_node.next;
        size--;
        return;
      }
      previous_node = current_node;
      current_node = previous_node.next;
    }
  }
  
  public void _print()
  {
    System.out.println("___________________");
    Node current_node = head;
    while(current_node != null)
    {
       System.out.println("X: " + current_node.data[0] + ", Y: " + current_node.data[1]);
       current_node = current_node.next;
    }
  }
  
}
public class Node
{
  int[] data;
  Node next;
  public Node(int[] data)
  {
    this.data = data;
    this.next = null;
  }
}
