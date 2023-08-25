// Object Modeling Example Code
// Dong Hyuk Park
// I'm replicating ice cream object using instancing
// The middle part of the rubik's cube is rotating + Ice cream is translating vertically
// story : the rubik's cube is alone in the space. He start spinning his middle part of the cube
// because he bored. Suddenly, the ice cream pop out!!! Few seconds later he notices that this is icream and start rotating with the joy!
// spotlight() is added for additional light source.


float time = 0;   // time is used to move objects from one frame to another
boolean generateImages = false; // For instructors. Automatically generate images (and create a video manually).

// setting color variable
int white = color(255, 255, 255);
int dark_grey = color(96, 96, 96);
int blue = color(0, 0, 255);
int deeo_sky_blue = color(0, 191, 255);
int yellow = color(255, 255, 0);
int dark_grey_blue = color(57, 115, 115);
int blue2 = color(70, 70, 117);
int orange = color(255, 165, 0);
int brown = color(172, 90, 0);
int gold = color(255, 215, 0);

// p2b part ******
float eyeX = 0;
float eyeY = 0;
float eyeZ = 110;
float upX = 0;
float upY = 0;
float upZ = 0;
float cameraSpeed = 0.005; 

// variable for cube
float cubeSize = 10;
float cubeGap = 1;

// p2b **********
float midRotationSpeed = 1.0;
float iceCreamYposition = 30;


void setup() {
  size(800, 800, P3D); // If 3D mode is not working on your mac, download the latest version of Processing with a proper version: "Apple Silicon" or "Intel 64-bit".
  frameRate(30);      // this seems to be needed to make sure the scene draws properly --rotation cameraSpeed
  perspective(60 * PI / 180, 1, 0.1, 1000); // 60-degree field of view_perspective(fov, aspect, near, far)
}

void draw() {
  time += 0.05;
  
  // p2b part -- Zoom in and out ***************
        
  if (time > 7 && time < 14) {
    eyeX += (upX - eyeX) * cameraSpeed;
    eyeY += (upY - eyeY) * cameraSpeed;
    eyeZ += (upZ - eyeZ) * cameraSpeed;
  } else if (time < 7){
    eyeX -= (upX - eyeX) * cameraSpeed;
    eyeY -= (upY - eyeY) * cameraSpeed;
    eyeZ -= (upZ - eyeZ) * cameraSpeed;
  }     
  
  camera(eyeX, eyeY, eyeZ, upX, upY, upZ, 0, 1, 0);
  

  //camera (0, 0, 100, 0, 0, 0, 0, 1, 0); // position of the virtual camera
  background (0, 0, 17); // making it black

  // set up the lights
  ambientLight(50, 50, 50); //sets the color and intensity of the ambient light. (R,G,B)
  lightSpecular(255, 255, 255); // (R,G,B)set the specular highlight that appears on the surface of objects when they reflect light
  directionalLight (100, 100, 100, -0.3, 0.5, -1); // (R,G,B,pointung to x,y,z directioin)sets up a directional light source
  
  // p2b added one light source *****
  spotLight(180, 180, 180, 20, 20, 20, 0, -0.4, -0.4, PI / 2 * time, 2);

  // set some of the surface properties
  noStroke(); // removes the stroke(outline) of shapes = the edges of the shapes will not be visible.
  specular (180, 180, 180); // (R,G,B) specular highlight that appears on the surface of objects when they reflect light. 
  shininess (15.0); /// sets the shininess or reflectivity of the surface of the objects ->  lower the value, the more reflective?


  pushMatrix();
  
  if (time > 15) {
    rotateY(time); // Rotate around the vertical axis --- Rotate everything together
  }


  // ==============================
  // Object modeling begins
  // ==============================  
  
  // Rotate top row
  pushMatrix();
  rotateX(midRotationSpeed * time);
  drawMiddleRow(midRotationSpeed * time);
  popMatrix();
  
  
  // Draw the FRONT center 
  drawCube(white, cubeSize, -cubeSize - cubeGap, 0, 0);
  // Draw front edges
  drawCube(dark_grey, cubeSize, -cubeSize - cubeGap, -cubeSize - cubeGap, 0);
  drawCube(blue2, cubeSize, -cubeSize - cubeGap, 0, cubeSize + cubeGap);
  drawCube(blue, cubeSize, -cubeSize - cubeGap, cubeSize + cubeGap, 0);
  drawCube(deeo_sky_blue, cubeSize, -cubeSize - cubeGap, 0, -cubeSize - cubeGap); 
  // Draw the front corners
  drawCube(brown, cubeSize, -cubeSize - cubeGap, -cubeSize - cubeGap, -cubeSize - cubeGap); 
  drawCube(orange, cubeSize, -cubeSize - cubeGap, -cubeSize - cubeGap, cubeSize + cubeGap); 
  drawCube(dark_grey_blue, cubeSize, -cubeSize - cubeGap, cubeSize + cubeGap, -cubeSize - cubeGap); 
  drawCube(blue2, cubeSize, -cubeSize - cubeGap, cubeSize + cubeGap, cubeSize + cubeGap);   
  
  
  // Draw the BACK center 
  drawCube(white, cubeSize, cubeSize + cubeGap, 0, 0);
  // Draw back edges
  drawCube(brown, cubeSize, cubeSize + cubeGap, -cubeSize - cubeGap, 0);
  drawCube(dark_grey_blue, cubeSize, cubeSize + cubeGap, 0, cubeSize + cubeGap);
  drawCube(dark_grey, cubeSize, cubeSize + cubeGap, cubeSize + cubeGap, 0);
  drawCube(blue, cubeSize, cubeSize + cubeGap, 0, -cubeSize - cubeGap);
  // Draw the back corners
  drawCube(blue2, cubeSize, cubeSize + cubeGap, -cubeSize - cubeGap, -cubeSize - cubeGap); 
  drawCube(orange, cubeSize,cubeSize + cubeGap, -cubeSize - cubeGap, cubeSize + cubeGap); 
  drawCube(deeo_sky_blue, cubeSize, cubeSize + cubeGap, cubeSize + cubeGap, -cubeSize - cubeGap); 
  drawCube(yellow, cubeSize, cubeSize + cubeGap, cubeSize + cubeGap, cubeSize + cubeGap);   


  // Draw center of the crown
  fill(gold);
  pushMatrix();
  translate(0, -25, 0); 
  scale(5, 10, 5);
  cone(400);
  popMatrix();
  
  // Draw spikes on the crown
  for (int i = 0; i < 10; i++) {
    pushMatrix();
    rotateY(2 * PI * i /10.0);
    translate(10, -22,0);
    scale(3, 6, 3);
    cone(5);
    popMatrix();
    
    
  }
  
  
  //********  p2b ****************
  
  iceCreamYposition = 25 + 10 * cos(time);
  
  
  if (time > 3) {
  
  // Draw the ice cream cone - instance 1
  pushMatrix();
  translate(-30, iceCreamYposition, 0);
  scale(10);
  drawIceCream();
  popMatrix();
  
  // Draw the ice cream cone - instance 2
  pushMatrix();
  translate(30, iceCreamYposition, 0);
  scale(10);
  drawIceCream();
  popMatrix();
  
  }
  
    


  // ==============================
  // Object modeling ends
  // ==============================  
  // pop the rotation matrix
  popMatrix();

  
  pushMatrix();
  translate(0, 40, 0);
  scale(0.1, 0.1, 0.1);
  fill(gold);
  textAlign(CENTER);
  textSize(48); 
  text("mysterious rubik's cube King", 0, 0);
  popMatrix();
  
  // Single frame capture with 'c' key
  if (keyPressed && key == 'c') {
    saveFrame("p2-######.png");
  }
  if (generateImages && frameCount < 300) {
    saveFrame("p2-######.png");
  }
}

//Draw a cone pointing in the -y direction (up), with radius 1, with y in range [-1, 1]
void cone(int sides) {
  // draw triangles making up the sides of the cone
  for (int i = 0; i < sides; i++) {
    float theta = 2.0 * PI * i / sides;
    float theta_next = 2.0 * PI * (i + 1) / sides;

    beginShape();
    normal(cos(theta), 0.6, sin(theta));
    vertex(cos(theta), 1.0, sin(theta));
    normal(cos(theta_next), 0.6, sin(theta_next));
    vertex(cos(theta_next), 1.0, sin(theta_next));
    normal(0.0, -1.0, 0.0);
    vertex(0.0, -1.0, 0.0);
    endShape();
  }
    // draw the cap of the cone
  beginShape();
  for (int i = 0; i < sides; i++) {
    float theta = 2.0 * PI * i / sides;
    vertex(cos(theta), 1.0, sin(theta));
  }
  endShape();
}


// Function for drawing cube
void drawCube(int cube_color, float cube_size, float x, float y, float z) {
  fill(cube_color);
  pushMatrix();
  translate(x, y, z);
  box(cube_size, cube_size, cube_size);
  popMatrix();
  
}

// p2b part ********************
void drawMiddleRow(float rotate) {
  // Draw the CENTER 
  drawCube(white, cubeSize, 0, 0, 0);
  // Draw the center edges
  drawCube(yellow, cubeSize, 0, -cubeSize - cubeGap, 0);
  drawCube(deeo_sky_blue, cubeSize, 0, 0, cubeSize + cubeGap);
  drawCube(dark_grey, cubeSize, 0, cubeSize + cubeGap, 0);
  drawCube(blue2, cubeSize, 0, 0, -cubeSize - cubeGap); 
  //Draw the center corner
  drawCube(dark_grey_blue, cubeSize, 0, -cubeSize - cubeGap, -cubeSize - cubeGap); 
  drawCube(blue, cubeSize, 0, cubeSize + cubeGap, cubeSize + cubeGap);
  drawCube(brown, cubeSize, 0, -cubeSize - cubeGap, cubeSize + cubeGap); 
  drawCube(orange, cubeSize, 0, cubeSize + cubeGap, -cubeSize - cubeGap);
}


void drawIceCream() {
  
  //ice cream sphere
  fill(255, 192, 190);
  pushMatrix();
  translate(0, - 0.7, 0);
  sphere(1);
  popMatrix();
    
  //cone
  fill(186, 137, 94);
  pushMatrix();
  translate(0, 0.3, 0);
  rotateX(PI);
  cone(20);
  popMatrix();
}
