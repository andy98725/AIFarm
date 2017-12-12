/// Unit management \\\

class Unit {
  int id;
  int state = 0;
  color col;
  float life;
  float score;
  Unit(int ID) {
    id = ID;
    col = getcol(ID);
    life = getlife(ID);
    score = getscore(ID);
  }
  //Used primarily in subclasses.
  void logic(int x, int y) {
  }
  color getColor() {
    return col;
  }
}


class soilUnit extends Unit {
  color col2 = color(lerp(90,120,random(1)), lerp(190,220,random(1)), lerp(90,120,random(1)));
  soilUnit() {
    super(ID_SOIL);
  }
  soilUnit(int state) {
    super(ID_SOIL);
    this.state = state;
  }
  void logic(int x, int y) {
    if (state == 1) {
      if (y > 0 && Map[x][y-1] != null) state = 0;
    } else {
      if ((y == 0 || Map[x][y-1] == null) && random(10) > 9) {
        for (int i = constrain(x-1, 0, width-1); i < constrain(x+1, 0, width-1); i++) for (int j = constrain(y-1, 0, height-1); j < constrain(y+1, 0, height-1); j++) {
          if (Map[i][j] != null && Map[i][j].id == ID_SOIL && Map[i][j].state == 1) state = 1;
        }
      }
    }
  }
  color getColor() {
    if (state == 1) return col2;
    else return col;
  }
}
//Unit that falls
class gravUnit extends Unit {
  float weight;
  gravUnit(int ID) {
    super(ID);
    weight = getweight(ID);
  }
  void logic(int x, int y) {
    fall(x,y);
  }
  boolean fall(int x, int y){
    if (y < height-1) {
      boolean d = (Map[x][y+1] == null || (Map[x][y+1] instanceof gravUnit && ((gravUnit)Map[x][y+1]).weight < weight));
      boolean dl = (x > 0 && (Map[x-1][y+1] == null || (Map[x-1][y+1] instanceof gravUnit && ((gravUnit)Map[x-1][y+1]).weight < weight)));
      boolean dr = (x < width-1 && (Map[x+1][y+1] == null  || (Map[x+1][y+1] instanceof gravUnit && ((gravUnit)Map[x+1][y+1]).weight < weight)));
      if (d) {
        Unit buffer = Map[x][y+1];
        Map[x][y+1] = Map[x][y];
        Map[x][y] = buffer;
      } else {
        if (dl && dr) {
          if (random(2) >= 1) dl = false;
          else dr = false;
        }
        if (dl) {
        Unit buffer = Map[x-1][y+1];
          Map[x-1][y+1] = Map[x][y];
          Map[x][y] = buffer;
        }
        if (dr) {
        Unit buffer = Map[x+1][y+1];
          Map[x+1][y+1] = Map[x][y];
          Map[x][y] = buffer;
        }
      }
      return d || dl || dr;
    }
    else return false;
  }
}
//Water. Special physics
class waterUnit extends gravUnit{
  float weight;
  waterUnit(int ID){
    super(ID);
  }
  void logic(int x, int y){
    //Falls fast, and moves to the side too
    if(!super.fall(x,y)) slide(x,y);
    if(!super.fall(x,y)) slide(x,y);
    if(!super.fall(x,y)) slide(x,y);
    
  }
  void slide(int x, int y){
      
      boolean l = (x > 0 && (Map[x-1][y] == null || (Map[x-1][y] instanceof gravUnit && ((gravUnit)Map[x-1][y]).weight < weight)));
      boolean r = (x < width-1 && (Map[x+1][y] == null  || (Map[x+1][y] instanceof gravUnit && ((gravUnit)Map[x+1][y]).weight < weight)));
      if(l && r){
        //If free to move on both sides
        //25% chance to dissapear
        if(random(8) <= 1){
          Map[x][y] = null;
          return;
        }
        //Otherwise choose one
        if(random(2) >= 1) l = false;
        else r = false;
      }
      if(l){
        Unit buffer = Map[x-1][y];
          Map[x-1][y] = Map[x][y];
          Map[x][y] = buffer;
      }
      if(r){
        Unit buffer = Map[x+1][y];
          Map[x+1][y] = Map[x][y];
          Map[x][y] = buffer;
      }
      
    }
    
}
class cloudUnit extends Unit{
  cloudUnit(int ID){
    super(ID);
  }
  void logic(int x, int y){
    if(raining && (y < height-1 && Map[x][y+1] == null) && random(maxStrength) < weatherStrength){
      NextMap[x][y+1] = makeUnit(ID_WATER);
    }
  }
}
//Creating units
Unit makeUnit(int ID) {
  //This is how I do default values
  return makeUnit(ID, 0);
}
Unit makeUnit(int ID, int state) {
  switch(ID) {
  default: 
  case ID_STONE:
    return new Unit(ID);
  case ID_SOIL:
    return new soilUnit(state);
  case ID_SAND:
    return new gravUnit(ID);
  case ID_WATER:
    return new waterUnit(ID);
  case ID_CLOUD:
    return new cloudUnit(ID);
  }
}
/// ID GUIDE \\\
//0- Stone
final int ID_STONE = 0;
//1- Soil
final int ID_SOIL = 1;
//2- Wood
final int ID_WOOD = 2;
//3- Leaves
final int ID_LEAVES = 3;
//4- Sand
final int ID_SAND = 4;
//5- Water
final int ID_WATER = 5;
//6- Cloud
final int ID_CLOUD = 6;

color getcol(int ID) {
  switch(ID) {
  default: 
    return color(0);
  case ID_STONE: 
    return color(lerp(78,82,random(1)));
  case ID_SOIL: 
    return color(lerp(150,130,random(1)), lerp(100,110,random(1)), lerp(75,85,random(1)));
  case ID_WOOD: 
    return color(lerp(120,140,random(1)), lerp(50,70,random(1)), lerp(10,15,random(1)));
  case ID_LEAVES: 
    return color(lerp(100,125,random(1)), lerp(200,250,random(1)), lerp(0,5,random(1)));
  case ID_SAND: 
    return color(lerp(245,220,random(1)), lerp(230,205,random(1)), lerp(110,90,random(1)));
  case ID_WATER:
    return color(lerp(40,38,random(1)), lerp(50,45,random(1)), lerp(255,230,random(1)));
  case ID_CLOUD:
    return color(lerp(220,240,random(1)));
  }
}
float getlife(int ID) {
  switch(ID) {
  default: 
    return -1;
  case ID_STONE: 
    return 50;
  case ID_SOIL: 
    return 20;
  case ID_WOOD: 
    return 50;
  case ID_LEAVES: 
    return 5;
  case ID_SAND: 
    return 20;
  case ID_WATER:
    return 1;
  case ID_CLOUD:
    return 3;
  }
}
float getscore(int ID) {
  switch(ID) {
  default: 
    return 0;
  case ID_STONE: 
    return 1; 
  case ID_SOIL: 
    return 0; 
  case ID_WOOD: 
    return 5;
  case ID_LEAVES: 
    return 0;
  case ID_SAND: 
    return 0;
  case ID_WATER:
    return 1;
  case ID_CLOUD:
    return 200;
  }
}

float getweight(int ID) {
  switch(ID) {
    default:
    case ID_SAND:
      return 5;
    case ID_WATER:
      return 1;
  }
}