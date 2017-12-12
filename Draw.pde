/// Different rendering methods
final int OneScreen = 0;
final int CamMode = 1;
// This variable determines how the screen is handled
int RenderMode = OneScreen;
void draw(){
  logic();
  if(RenderMode == OneScreen)
    drawOneScreen();
  else if(RenderMode == CamMode)
    drawCamera();
  drawFrame();
}

//One screen rendering
color skycol = color(100,200,255);
void drawOneScreen(){
  background(skycol);
  for(int i = 0; i < width; i++) for(int j = 0; j < height; j++){
    if(Map[i][j] != null){
      //set color to map.color, draw point at point.
      stroke(Map[i][j].getColor());
      point(i,j);
    }
    else if(Background[i][j]){
      stroke(bgcol);
      point(i,j);
    }
  }
}

//Camera logic
void initializeCamera(){
  
}

void drawCamera(){
  
}


void drawFrame() {
    String fr = str(frameCount);
    textSize(20);
    fill(0);
    float xx = 20, yy = 20;
    for (int i = -1; i <= 1; i++) for (int j = -1; j <= 1; j++) {
      text(fr, xx+i, yy+j);
    }
    fill(255);
    text(fr, xx, yy);
  }