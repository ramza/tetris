boolean [][] iShape = { {false, true, false, false},
                        {false, true, false, false},
                        {false, true, false, false},
                        {false, true, false, false} };
                  
boolean [][] jShape = { {false, false, false},
                        {true, true, true},
                        {false, false, true} };
                        
boolean [][] lShape = { {false, false, true},
                        {true, true, true},
                        {false, false, false} };
                        
boolean [][] oShape = { {true, true},
                        {true, true} };
                        
boolean [][] zShape = { {false, true, false},
                        {true, true, false},
                        {true, false, false} };
                        
boolean [][] sShape = { {true, false, false},
                        {true, true, false},
                        {false, true, false} };
                        
boolean [][] tShape = { {true, false, false},
                        {true, true, false},
                        {true, false, false} };
             

enum DIRECTION {DOWN, RIGHT, LEFT}

static int BOARDWIDTH = 10;
static int BOARDHEIGHT = 16;
static int TILESIZE = 20;

int offsetX;
int offsetY;

boolean [][] tiles;

int time;
int wait = 250;

boolean canPlay = true;

Shape shape;

void setup() {
  background(150);
  size(640, 480);
  offsetX = (width - (BOARDWIDTH * TILESIZE))/2;
  offsetY = (height - (BOARDHEIGHT * TILESIZE))/2;
  
  InitializeBoard();
  drawBoard();
  shape = new Shape();
  shape.drawShape();
  time = millis();
}

void draw() {
  // tick
  if ( millis() - time >= wait) {
     time = millis();
     if ( shape.isBlockedDown() ) {
       shape.drawShapeToBoard();
       shape = new Shape();
       background(150);
     } else shape.move(DIRECTION.DOWN);
     canPlay = true;
     drawBoard();
     shape.drawShape();
  }
  
  clearLines();
}

void keyPressed() {
  if ( key == CODED && canPlay) {
     if (keyCode == RIGHT) {
       shape.move(DIRECTION.RIGHT);
       canPlay = false;
     }
     else if ( keyCode == LEFT) {
       shape.move(DIRECTION.LEFT);
       canPlay = false;
     }
     else if (keyCode == DOWN) {
       shape.move(DIRECTION.DOWN); 
       canPlay = false;
     }
  }
  if ( key == 'b' || key == 'B' && canPlay ) {
       print("b");
       shape.rotateMatrix(DIRECTION.RIGHT);
       canPlay = false;
     }
  else if ( key == 'v' || key == 'V' && canPlay) {
     shape.rotateMatrix(DIRECTION.LEFT);
     canPlay = false;
  }
}

void clearLines() {
  
  ArrayList rows = new ArrayList();
  int counter = 0;

  // check for a line to clear
  for ( int j = 0; j < BOARDHEIGHT; j++) {
    counter = 0;
   for ( int i = 0; i < BOARDWIDTH; i++) {
     if ( tiles[i][j] == true ) {
       counter++;
       if ( j == 0 ) setup();
     }
   }
    if ( counter == BOARDWIDTH ) { 
      rows.add(j);
    }
  }
  
  for ( int j = 0; j < rows.size(); j++) {
    for ( int i = 0; i < BOARDWIDTH; i++) {
     tiles[i][(int)rows.get(j)] = false; 
    }
  }
  if ( rows.size() > 0 ) {
   for (int x = 0; x < rows.size(); x++ ) {
    for ( int j = (int)rows.get(rows.size()-1) - 1; j > 0; j--) {
     for ( int i = 0; i < BOARDWIDTH; i++) {
      if ( tiles[i][j] == true) {
       tiles[i][j] = false;
       tiles[i][j+1] = true;
     }
    }
   }
  }
 }
}

void InitializeBoard() {
  tiles = new boolean [BOARDWIDTH][BOARDHEIGHT];
  for (int j = 0; j < BOARDHEIGHT; j++) {
    for ( int i = 0; i < BOARDWIDTH; i++) {
      if ( j > 10) tiles[i][j] = true;
      else
      tiles[i][j] = false;
    }
  }
}

void drawBoard() {
 
  for ( int j = 0; j < BOARDHEIGHT; j++) {
     for ( int i = 0; i < BOARDWIDTH; i++) {
       if ( tiles[i][j] == false)
         fill(255);
       else fill(0);
       stroke(0);
       rect(offsetX + i * TILESIZE, offsetY + j * TILESIZE, TILESIZE, TILESIZE);
     }
  }
}

class Shape {
  // a point to hold the position of the shapeMatrix's
  // upper left position on the tile map
  PVector pivot;
  int shapeType;
  boolean[][] shapeMatrix;
  color shapeColor;
  int offsetLeft;
  int offsetRight;
  int offsetDown;

  Shape() {
      InitializeShapeMatrix();
      pivot = new PVector((int)(BOARDWIDTH/2-shapeMatrix.length/2),0);
  }
  
  void InitializeShapeMatrix() {
    shapeType = (int)random(7);
    switch ( shapeType) {
       case 0:
         shapeMatrix = iShape;
         break;
       case 1:
         shapeMatrix = lShape;
         break;
       case 2:
          shapeMatrix = jShape;
          break;
       case 3:
         shapeMatrix = oShape;
         break;
       case 4:
         shapeMatrix = zShape;
         break;
       case 5:
         shapeMatrix = sShape;
         break;
       case 6:
         shapeMatrix = tShape;
         break;
    }
    setOffset();
    println("offset right: " + offsetRight + " offset left: " + offsetLeft + " offset down: " + offsetDown);
  }
  
  void setOffset() {
    //shapeMatrix = jShape;
    offsetLeft = 3;
    offsetDown = 0;
    offsetRight = 0;
  
    for ( int j = 0; j < shapeMatrix.length; j++) {
     for ( int i = 0; i < shapeMatrix.length; i++) {
       if ( shapeMatrix[i][j] == true ) {
             if ( i > offsetRight){
                offsetRight = i;
              }
              if ( i < offsetLeft) {
               offsetLeft = i; 
              }
              if ( j > offsetDown) {
                offsetDown = j; 
              }
         }
       }
    }
   
  }
  
  public void drawShape() {
    for ( int j = 0; j < shapeMatrix.length; j++) { 
      for ( int i = 0; i < shapeMatrix.length; i++) {
        if ( shapeMatrix[i][j] == true) { 
         fill(0);
         stroke(0);
         rect(offsetX + (i+int(pivot.x)) * TILESIZE, offsetY + (j + int(pivot.y)) * TILESIZE, TILESIZE, TILESIZE);
        }  
      }
    }
  }
  
  public void drawShapeToBoard() {
    
    for ( int i = 0; i < shapeMatrix.length; i++) {
     for ( int j = 0; j < shapeMatrix.length; j++) {
       if (shapeMatrix[i][j] == true ) {
         tiles[(int)pivot.x + i][(int)pivot.y + j] = true; 
       }
     }
    }
  }
  
  public boolean isBlockedDown() {
    if ( pivot.y + offsetDown >= BOARDHEIGHT - 1 ) return true;
    for ( int j = 0; j < shapeMatrix.length; j++) {
     for ( int i = 0; i < shapeMatrix.length; i++) {
       if ( shapeMatrix[i][j] == true) {
         if (pivot.x + i > BOARDWIDTH - 1 ) return false;
           else if (tiles[ (int)pivot.x + i][(int)pivot.y + j + 1] == true) {
           return true;
          }
         }
       }
   }
   
    return false;
  }
  
  boolean isBlockedLeft() {
    if ( pivot.x + offsetLeft <= 0 ) return true;
    for ( int j = 0; j < shapeMatrix.length; j++) {
     for ( int i = 0; i < shapeMatrix.length; i++) {
        if ( shapeMatrix[i][j] == true) {
          if ( tiles[(int)pivot.x + i - 1] [(int)pivot.y + j] == true) return true; 
        }
     }
    }
    
    return false;
  }
  
  boolean isBlockedRight() {
    if ( pivot.x + offsetRight >= BOARDWIDTH - 1 ) return true;
   for ( int j = 0; j < shapeMatrix.length; j++) {
     for ( int i = 0; i < shapeMatrix.length; i++) {
        if ( shapeMatrix[i][j] == true) {
           if ( tiles[(int)pivot.x + i + 1] [(int)pivot.y + j] == true) return true; 
        }
     }
    }
    return false;
  }
  
  void rotateMatrix(DIRECTION dir) {
    boolean[][] newMatrix = new boolean[shapeMatrix.length][shapeMatrix.length];
    // rotate clockwise
    if(dir == DIRECTION.RIGHT) {
      for ( int j = 0; j < shapeMatrix.length; j++) {
       for (int i = 0; i < shapeMatrix.length; i++ ) {
        newMatrix[i][j] = shapeMatrix[j][shapeMatrix.length - 1 - i];
       }
      }
    }
    else if ( dir == DIRECTION.LEFT) {
      for ( int j = 0; j < shapeMatrix.length; j++) {
       for (int i = 0; i < shapeMatrix.length; i++ ) {
         newMatrix[i][j] = shapeMatrix[shapeMatrix.length - 1 - j][i];
       }
      }
    }
    
    for ( int j = 0; j < newMatrix.length; j++) {
     for (int i = 0; i < newMatrix.length; i++) {
      if ( newMatrix[i][j] == true ) {
        if ( (int)pivot.x + i >= BOARDWIDTH || pivot.x + i < 0 || pivot.y + j >= BOARDHEIGHT) return;
      }
     }
    }
    
    shapeMatrix = newMatrix;
    setOffset();
  }
  
  void move(DIRECTION dir) {
    
    if ( dir == DIRECTION.DOWN) {
   
      if ( !isBlockedDown() ) {
        pivot.y += 1;
      }
    } else if ( dir == DIRECTION.LEFT) {
      if ( !isBlockedLeft() )
          pivot.x -= 1;
 
    } else if (dir == DIRECTION.RIGHT) {
      if ( !isBlockedRight() )
        pivot.x += 1;
    }
  }
  
}