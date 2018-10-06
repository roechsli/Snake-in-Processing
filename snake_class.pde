class Snake{
  BodyPart head;
  BodyPart tail;
  int died = 0;
  int direction = floor(random(4));;
  int snake_length = 1;
  Snake(int headX, int headY) {
    head = new BodyPart(headX, headY); 
    tail = head;
  }
      
  void append(int x, int y) {
    BodyPart current = head;
    while (current.next != null) {
      current = current.next;
    }
    current.next = new BodyPart(x,y);
    current.next.previous = current;
    tail = current.next;
    snake_length++;
  }

  void draw_snake(){
    BodyPart current = head;
    draw_rectangle(current.xCell, current.yCell, "head");
    //println("head at x = ", current.xCell, " and y = ", current.yCell);
    current = current.next;
    while (current.next != null) {
      //println("x = ", current.xCell, " and y = ", current.yCell);
      draw_rectangle(current.xCell, current.yCell, "body");
      current = current.next;
    }
    
    //println("x = ", current.xCell, " and y = ", current.yCell);
    draw_rectangle(current.xCell, current.yCell, "body");
  }
  
  void test_iterate_back(){
    BodyPart current = tail;
    println("tail at x = ", current.xCell, " and y = ", current.yCell);
    current = current.previous;
    while (current.previous != null) {
      println("x = ", current.xCell, " and y = ", current.yCell);
      current = current.previous;
    }
    println("head x = ", current.xCell, " and y = ", current.yCell);
  }
  
  int get_length() {
    return snake_length;
  }
  
  int get_dir() {
    return direction;
  }
  
  int check_collision(int cellX, int cellY) {
    BodyPart current = head;
    if (head.xCell == cellX && head.yCell == cellY) {
      return 2;
    }
    while (current.next != null && current.next.next != null) {
      current = current.next;
      if (current.xCell == cellX && current.yCell == cellY) {
        return 1;
      }
    }
    return 0;
  }
  
  
  void propagate() {
    int goal_x = (direction%2)*(2-direction) + head.xCell;
    int goal_y = (1-direction%2)*(-1+direction) + head.yCell;
    int collision_value = checkCollision(goal_x, goal_y);
    if (collision_value == 3) { //fruit
      BodyPart p = new BodyPart(goal_x, goal_y);
      head.previous = p;
      p.next = head;
      head = p;
      createFruit();
      snake_length++;
    } else if (collision_value > 0) { //fruit
      if (VERBOSE) println("collision with walls");
      died = 1;
    } else if (collision_value < 0) { //fruit
      if (VERBOSE) println("collision with body");
      died = 1;
    } else {
      if (VERBOSE) println("started propagation");
      BodyPart current = tail;
      while (current.previous != null) {
        current.xCell = current.previous.xCell;
        current.yCell = current.previous.yCell;
        current = current.previous;
      }
      current.xCell = goal_x;
      current.yCell = goal_y;
      if (VERBOSE) println("finished propagation");
    }
    
  }
  
  int is_dead() {
    return died;
  }
  
}

class BodyPart{
  BodyPart next;
  BodyPart previous;
  int xCell, yCell;
  
  BodyPart(int xcellindex, int ycellindex) {
    xCell = xcellindex;
    yCell = ycellindex;
    next = null;
    previous = null;
  }
}

class Fruit{
  int xCell, yCell;
  int reward;
  
  Fruit(int xcellindex, int ycellindex, int framerate) {
    xCell = xcellindex;
    yCell = ycellindex;
    reward = framerate;
    
  }
  
  void draw_fruit() {
    draw_rectangle(xCell, yCell, "fruit");
  }
    
}
