/* ---------- AI Farm ---------- \\
To Do:
 * Improve map generation
 * Drawing map with camera
 * Different unit types
 * AI type
 * Convert background to separate array


\\ ---------- - - - - ----------- */
import java.util.*;


void setup(){
  size(400,400);
  noStroke();
  noSmooth();
  frameRate(30);
  
  long rand = new Date().getTime();
  randomSeed(rand);
  noiseSeed(rand);
  genMap();
  if(RenderMode == CamMode)
  initializeCamera();
}

void keyPressed(){
  if(key == CODED){
    switch(keyCode){
      default: break;
    }
  }
  else{
    switch(key){
      default: break;
      case ' ': setup(); break;
    }
  }
}