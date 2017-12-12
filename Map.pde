/// Map management

//Noise scale
float scale = 0.01;
//Cave value. 1 is no caves, 0 is only caves.
float caves = 0.62;
//Same thing
float sand = 0.7;
float dirt = 0.7;
float clouds = 0.5;

int skyline = 120;
Unit[][] Map;
Unit[][] NextMap;
boolean[][] Background;
color bgcol = color(40);

//Generate map
void genMap() {
  //Define
  Map = new Unit[width][height];
  Background = new boolean[width][height];
  //Clear
  for (int i = 0; i < width; i++) for (int j = 0; j < width; j++) {
    Map[i][j] = null;
    Background[i][j] = false;
    
  }
  //Generate stone/soil lines
  for (int i = 0; i < width; i++) {
    float hei = (height) * noise(scale * i);
    float dirtHei = 5 * noise(0, scale * i);
    //Stone
    for (int j = height-1; j > (height - hei) + dirtHei; j--) {
      Map[i][j] = makeUnit(ID_STONE); //Stone
      Background[i][j] = true;
    }
    for (int j = constrain(ceil((height - hei) + dirtHei),0,height-1); j > height - hei; j--) {
      Background[i][j] = true;
      if (j-1 <= hei)
        Map[i][j] = makeUnit(ID_SOIL, 1); //Grass
      else
        Map[i][j] = makeUnit(ID_SOIL, 0); //Soil
    }
  }
  //Generate cave system
  for(int i = skyline; i < width; i++) for(int j = skyline; j < height; j++){
    if(noise(scale*2*i, scale*2*j) > caves && Map[i][j] != null){
      Map[i][j] = null;
    }
  }
  //Generate dirt
  for(int i = skyline; i < width; i++) for(int j = skyline; j < height; j++){
    if(noise(width*6+scale*i, random(scale*j/200), height*6+scale*j) > dirt && Map[i][j] != null){
      if(Map[i][j-1] == null && random(10) <= 1)
      Map[i][j] = makeUnit(ID_SOIL, 1);
      else
      Map[i][j] = makeUnit(ID_SOIL, 0);
    }
  }
  //Generate sand
  for(int i = 0; i < width; i++) for(int j = 0; j < height; j++){
    if(noise(width*2+scale*2*i, height*2+scale*2*j,random(scale)) > sand && Map[i][j] != null){
      Map[i][j] = makeUnit(ID_SAND);
    }
  }
  
  //Generate clouds
  for(int j = 0; j < skyline; j++){
    float thresh = map(j,0,skyline,clouds,1);
  for(int i = 0; i < width; i++){
    if(noise(width*4+scale*i*2,height*4+scale*j*3) < 1-thresh){
      if(Map[i][j] == null) Map[i][j] = makeUnit(ID_CLOUD);
    }
  }
  }
  /*
  //Add temp sand
  for(int i = width/2-50; i < width/2+50; i++) for(int j = 0; j < 50-abs(width/2-i); j++){
    Map[i][j] = makeUnit(ID_WATER);
  }
  */
  //Speed up happening
  for(int l = 0; l < 250; l++){
    logic();
  }
}