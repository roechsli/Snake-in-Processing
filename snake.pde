/*
This is the first trial to create a snake game
Roman Oechslin
09. August 2018

%%%% TODO's:
delete snake when died?

*/

boolean VERBOSE = false;

int BOARD_LENGTH = 500;
int WINDOW_SIZE = 650;
int NUM_CELLS = 20; 
int FRAMERATE = 10;
int INIT_HEAD_OFFSET = 3;
boolean button_pressed = false;
boolean frozen = true;
int score = -FRAMERATE/10;

int counter = 0;

Fruit fruit;
Snake snake;

void setup(){
  size(650,650);
  frameRate(FRAMERATE*10);
  println("The game has loaded!");
  println("Press enter to start!");
  
  
  initSnake();
  createFruit();

}

void draw() {
  if (!frozen && counter == 0 && snake.died != 1) {
    drawBoard();
    updateScore();
    drawFruit();
    propagateSnake();
    drawSnake();
    button_pressed = false;
    frozen = boolean(snake.is_dead());
    if (VERBOSE) println("counter = ", counter);
  }
  counter = (counter + 1)%10;
  
  if (VERBOSE) println("counter = ", counter);
  if (VERBOSE) println("snake died = ", snake.died);
}

void drawBoard() {
  if (VERBOSE) println("I am drawing board");
  fill(255);
  rect((WINDOW_SIZE - BOARD_LENGTH)/2, (WINDOW_SIZE - BOARD_LENGTH)/2, BOARD_LENGTH, BOARD_LENGTH);
  
  for (int i = 0; i < NUM_CELLS; i++) {
    line((WINDOW_SIZE - BOARD_LENGTH)/2+ i*BOARD_LENGTH / NUM_CELLS, (WINDOW_SIZE - BOARD_LENGTH)/2, (WINDOW_SIZE - BOARD_LENGTH)/2+ i*BOARD_LENGTH / NUM_CELLS, WINDOW_SIZE - (WINDOW_SIZE - BOARD_LENGTH)/2);
    line((WINDOW_SIZE - BOARD_LENGTH)/2, (WINDOW_SIZE - BOARD_LENGTH)/2+ i*BOARD_LENGTH / NUM_CELLS, WINDOW_SIZE - (WINDOW_SIZE - BOARD_LENGTH)/2, (WINDOW_SIZE - BOARD_LENGTH)/2+ i*BOARD_LENGTH / NUM_CELLS);
  }
  
}

void initSnake() {
  int curr_x = ceil(random(NUM_CELLS-INIT_HEAD_OFFSET*2)) + INIT_HEAD_OFFSET;
  int curr_y = ceil(random(NUM_CELLS-INIT_HEAD_OFFSET*2)) + INIT_HEAD_OFFSET;
  snake = new Snake(curr_x, curr_y);
  
  int dir = (snake.get_dir()+2)%4;
  while (snake.get_length() < 3) {
    switch (dir) {
    case 0: // up
      if (checkCollision(curr_x, curr_y-1) != 0) {
        break;
      }
      curr_y = curr_y -1;
      snake.append(curr_x, curr_y);
      break;
    case 1: // right
      if (checkCollision(curr_x+1, curr_y) != 0) {
        break;
      }
      curr_x = curr_x +1;
      snake.append(curr_x, curr_y);
      break;
    case 2: // down
      if (checkCollision(curr_x, curr_y+1) != 0) {
        break;
      }
      curr_y = curr_y +1;
      snake.append(curr_x, curr_y);
      break;
    case 3: // left
      if (checkCollision(curr_x-1, curr_y) != 0) {
        break;
      }
      curr_x = curr_x -1;
      snake.append(curr_x, curr_y);
      break;
    }
    dir = floor(random(4));
  }
}

void createFruit() {
  int xCell = ceil(random(NUM_CELLS));
  int yCell = ceil(random(NUM_CELLS));
  while (checkCollision(xCell, yCell) != 0 ) { 
    xCell = ceil(random(NUM_CELLS));
    yCell = ceil(random(NUM_CELLS));
  }
  fruit = new Fruit(xCell, yCell, FRAMERATE);
  score += FRAMERATE/10;
  
}

void drawSnake() {
  if (VERBOSE) println("I am drawing snake");
  snake.draw_snake();
}

void drawFruit() {
  if (VERBOSE) println("I am drawing fruit");
  fruit.draw_fruit();
}

void keyPressed() {
  if (frozen && keyCode == 10) {
    frozen = false;
    score = -FRAMERATE/10;
    initSnake();
    createFruit();
  } 
  //println("pressed " + int(key) + " " + keyCode);
  if (!button_pressed) {
    if (keyCode == 37) {
      snake.direction = (snake.direction + 3)%4; 
      println("go left");
    }
    if (keyCode == 39) {
      snake.direction = (snake.direction + 1)%4;
      println("go right");
    }
    button_pressed = true;
  }
}

void updateScore() {
  fill(205);
  noStroke();
  rect(0,0,200,50);
  stroke(0);
  fill(0, 102, 153);
  textSize(32);
  String scoreText = "Score: " + str(score);
  text(scoreText, 10, 30); 
  
}


void propagateSnake() {
  if (VERBOSE) println("I am propagating");
  snake.propagate();
}

int checkCollision(int cellX, int cellY) {
  if (cellX < 0 || cellY < 0 || cellX >= NUM_CELLS || cellY >= NUM_CELLS) {
    return -1;
  }
  if (fruit != null && cellX == fruit.xCell && cellY == fruit.yCell) {
    return 3;
  }
  
  
  return snake.check_collision(cellX, cellY);
}

void draw_rectangle(int xCell, int yCell, String type) {
  switch (type) {
    case "fruit":
      fill(100,255,100);
      break;
    case "head":
      fill(255,100,100);
      break;
    case "body":
      fill(50);
      break;
  }
  int xstart = (WINDOW_SIZE - BOARD_LENGTH)/2+ xCell*BOARD_LENGTH / NUM_CELLS;
  int ystart = (WINDOW_SIZE - BOARD_LENGTH)/2+ yCell*BOARD_LENGTH / NUM_CELLS;
  rect(xstart, ystart, BOARD_LENGTH / NUM_CELLS, BOARD_LENGTH / NUM_CELLS);
}
