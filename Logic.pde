boolean raining = false;
//1 is light, 5 is heavy, 10 is flood
float weatherStrength = 2;
final float maxStrength = 100;
void logic(){
  //Grab data
  NextMap = Map;
  //Do translation and movement
  logic(ID_STONE);
  logic(ID_SOIL);
  logic(ID_WOOD);
  logic(ID_LEAVES);
  logic(ID_SAND);
  logic(ID_WATER);
  logic(ID_WATER);
  //Weather
  logic(ID_CLOUD);
  //Update
  Map = NextMap;
}
void logic(int ID){
  for(int i = width-1; i >= 0; i--) for(int j = height-1; j >= 0; j--){
    if(Map[i][j] != null && Map[i][j].id == ID) Map[i][j].logic(i,j);
    
  }
}

void raindrop(int x){
  println("drip " + frameCount);
  float size = 2 * sqrt(weatherStrength);
  //Circular
  for(int j = 0; j <= 2*size; j++) for(int i = constrain(round(x - sqrt(sq(size)-sq(size-j))),0,width-1); i <= constrain(round(x + sqrt(sq(size)-sq(size-j))),0,width-1); i++){
    if(Map[i][j] == null) NextMap[i][j] = makeUnit(ID_WATER);
  }
}