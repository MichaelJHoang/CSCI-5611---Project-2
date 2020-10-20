/*

  CSCI 5611 - Project 2
  Authors: Jeffrey Jia and Jon-Michael Hoang
  Date: // insert due date here
  Desc: // description of the code

*/

Camera camera;

Vec3 gravity = new Vec3 (0, 400, 0);
float radius = 2;

// starting position
Vec3 stringTop = new Vec3(200, 50, 0);
//Vec3 restLength = new Vec3(0, 40, 0);
float restLength = 20;
float horizontalRestLenght = 30;

float mass = 0.3;

// tuning parameters
float k = 320;
float kv = 2;
float hor_k = 320;
float hor_kv = 2;

float frictionConstant = -0.8;

int clothLength = 20;
int clothHeight = 20;
int numVertices = clothLength * clothHeight;
// row(column)
//ArrayList<ArrayList<Vec3>> clothVertexPositions = new ArrayList<ArrayList<Vec3>>();
//ArrayList<ArrayList<Vec3>> clothVelocities = new ArrayList<ArrayList<Vec3>>();

ArrayList <Vertex> clothVertices = new ArrayList <Vertex> ();

int selected = -1;

//Sphere to interact with cloth
float sphereRadius = 100;
Vec3 spherePos = new Vec3(512, 360, 200);
float sphereSpeed = 300;
Vec3 sphereVel = new Vec3(0,0,0);
float COR = 0.7; 

/*
  the int main() of Processing
*/
String windowTitle = "Swinging Rope";
void setup()
{
  size (1024, 720, P3D);
  surface.setTitle(windowTitle);
  
  
  camera = new Camera();
  
  
  // populate clothVertices with vertices with initial positions and velocities
  
  for (int i = 0; i < clothLength; i++)
    for (int j = 0; j < clothHeight; j++)
    {
      Vec3 tempPosition = new Vec3(stringTop.x + i * 30 + j * 10, stringTop.y + j * 50, 0);
      Vec3 tempVelocity = new Vec3(0, 0, 0);
      //Vertex tempVertex = new Vertex(tempPosition, tempVelocity, new Vec3(), new Vec3(), new Vec3(), new Vec3());
      Vec3 force = new Vec3(0, 0, 0);
      Vertex tempVertex = new Vertex(tempPosition, tempVelocity, new Vec3(), new Vec3(), new Vec3(), force);
      clothVertices.add(tempVertex);
    }
}
  
  // position
  // velo
  // accel
  // string f
  // damp f
  // force


/*
  function to draw based on the simulation code
*/
boolean paused = true;
void draw()
{
  beginShape(QUADS);
  normal(0, 0, 1);
  fill(50, 50, 200);
  vertex(-100, +100);
  vertex(+100, +100);
  fill(200, 50, 50);
  vertex(+100, -100);
  vertex(-100, -100);
  endShape();
  
  background(255, 255, 255);
  camera.Update(1.0 / 25 * frameRate);
  
  //update(.1);
  if (!paused) {
    for (int f = 0; f < 20; f++){
      update(1/(20*frameRate));
    }
  }
  
  
  pushMatrix();
  fill(180,40,60);
  translate(spherePos.x, spherePos.y, spherePos.z);
  sphere(sphereRadius);
  popMatrix();
  
  // First String
  pushMatrix();
  translate(clothVertices.get(clothHeight*0).position.x,clothVertices.get(clothHeight*0).position.y);
  //sphere(radius);
  vertex(0,0,0);
  popMatrix();
  
  for (int i = clothHeight*0; i < clothHeight*0 + clothHeight - 1; i++){
    pushMatrix();
    line(clothVertices.get(i).position.x,clothVertices.get(i).position.y,clothVertices.get(i).position.z,
         clothVertices.get(i+1).position.x,clothVertices.get(i+1).position.y, clothVertices.get(i+1).position.z);
    translate(clothVertices.get(i+1).position.x,clothVertices.get(i+1).position.y);
    //sphere(radius);
    vertex(0,0,0);
    popMatrix();
  }

  for (int stringColumn = 1; stringColumn < clothLength; stringColumn++){
    pushMatrix();
    translate(clothVertices.get(clothHeight*stringColumn).position.x,clothVertices.get(clothHeight*stringColumn).position.y);
    //sphere(radius);
    vertex(0,0,0);
    popMatrix();
    for (int i = clothHeight*stringColumn; i < clothHeight*stringColumn + clothHeight - 1; i++){
      pushMatrix();
      line(clothVertices.get(i).position.x,clothVertices.get(i).position.y, clothVertices.get(i).position.z,
           clothVertices.get(i+1).position.x,clothVertices.get(i+1).position.y, clothVertices.get(i+1).position.z);
      line(clothVertices.get(i).position.x,clothVertices.get(i).position.y,clothVertices.get(i).position.z,
           clothVertices.get(i - clothHeight).position.x,clothVertices.get(i - clothHeight).position.y,clothVertices.get(i - clothHeight).position.z);
      line(clothVertices.get(i).position.x,clothVertices.get(i).position.y,clothVertices.get(i).position.z,
           clothVertices.get(i+1 - clothHeight).position.x,clothVertices.get(i+1 - clothHeight).position.y, clothVertices.get(i+1 - clothHeight).position.z);
      if(i != clothHeight*stringColumn){
        line(clothVertices.get(i).position.x,clothVertices.get(i).position.y,clothVertices.get(i).position.z,
           clothVertices.get(i-1 - clothHeight).position.x,clothVertices.get(i-1 - clothHeight).position.y,clothVertices.get(i-1 - clothHeight).position.z);
      }
      translate(clothVertices.get(i+1).position.x,clothVertices.get(i+1).position.y);
      //sphere(radius);
      vertex(0,0,0);
      popMatrix();
    }
    pushMatrix();
    line(clothVertices.get(clothHeight*stringColumn + clothHeight - 1).position.x,clothVertices.get(clothHeight*stringColumn + clothHeight - 1).position.y, clothVertices.get(clothHeight*stringColumn + clothHeight - 1).position.z,
         clothVertices.get(clothHeight*stringColumn - 1).position.x,clothVertices.get(clothHeight*stringColumn - 1).position.y, clothVertices.get(clothHeight*stringColumn - 1).position.z);
    line(clothVertices.get(clothHeight*stringColumn + clothHeight - 1).position.x,clothVertices.get(clothHeight*stringColumn + clothHeight - 1).position.y, clothVertices.get(clothHeight*stringColumn + clothHeight - 1).position.z,
         clothVertices.get(clothHeight*stringColumn - 2).position.x,clothVertices.get(clothHeight*stringColumn - 2).position.y, clothVertices.get(clothHeight*stringColumn - 2).position.z);
    popMatrix();
    
  }
  //fill(180,40,60);
  //pushMatrix();
  //translate(spherePos.x, spherePos.y, spherePos.z);
  //sphere(sphereRadius);
  //popMatrix();
  if (paused)
    surface.setTitle(windowTitle + " [PAUSED - PRESS 'G' TO RESUME]");
  else
    surface.setTitle(windowTitle + " "+ nf(frameRate,0,2) + "FPS");
}



/*
  update function to handle simulation code?
*/
void update(float dt)
{ 
  //Reset accelerations each timestep (momenum only applies to velocity)
  for (int i = 0; i < clothVertices.size(); i++){
    clothVertices.get(i).acceleration = new Vec3(0,0,0);
    clothVertices.get(i).force = new Vec3(0,0,0);
    if (i != selected){
      clothVertices.get(i).acceleration.add(gravity);
    }
  }
  
  
  sphereVel = new Vec3(0,0,0);
  if (leftPressed) sphereVel.add(new Vec3(-sphereSpeed,0,0));
  if (rightPressed) sphereVel.add(new Vec3(sphereSpeed,0,0));
  if (change_y && upPressed) sphereVel.add(new Vec3(0,-sphereSpeed,0)); //inwards
  if (change_y && downPressed) sphereVel.add(new Vec3(0,sphereSpeed,0)); //outwards
  if (upPressed && !change_y) sphereVel.add(new Vec3(0,0,-sphereSpeed)); //inwards
  if (downPressed && !change_y) sphereVel.add(new Vec3(0,0,sphereSpeed)); //outwards
  sphereVel.clampToLength(sphereSpeed);
  if (shiftPressed) sphereVel.mul(2);
  spherePos.add(sphereVel.times(dt));
  
  for(int i = 0; i < clothVertices.size(); i++){
    if (clothVertices.get(i).position.distanceTo(spherePos) < (sphereRadius+radius)){
        Vec3 normal = (clothVertices.get(i).position.minus(spherePos)).normalized();
        clothVertices.get(i).position = spherePos.plus(normal.times(sphereRadius+radius).times(1.01));
        Vec3 velNormal = normal.times(dot(clothVertices.get(i).velocity,normal));
        clothVertices.get(i).velocity.subtract(velNormal.times(1 + COR));
      }
  }
  
  //vertical interaction top moves with bottom 
  for (int stringColumn = 0; stringColumn < clothLength; stringColumn++){
    //Compute (damped) Hooke's law for each spring
    for (int i = clothHeight*stringColumn; i < clothHeight*stringColumn + clothHeight - 1; i++){
      Vec3 diff = clothVertices.get(i+1).position.minus(clothVertices.get(i).position);
      float stringF = -k*(diff.length() - restLength);
      
      Vec3 stringDir = diff.normalized();
      float projVbot = dot(clothVertices.get(i).velocity, stringDir);
      float projVtop = dot(clothVertices.get(i+1).velocity, stringDir);
      float dampF = -kv*(projVtop - projVbot);
      
      Vec3 force = stringDir.times(stringF+dampF);
      //clothVertices.get(i).acceleration.add(force.times(-1.0/mass));
      //clothVertices.get(i+1).acceleration.add(force.times(1.0/mass));
      clothVertices.get(i).force = clothVertices.get(i).force.plus(force.times(-1.0/mass));
      clothVertices.get(i+1).force = clothVertices.get(i+1).force.plus(force.times(1.0/mass));
    }
  }
  //vertical interaction bottom moves with top
  for (int stringColumn = 0; stringColumn < clothLength; stringColumn++){
    //Compute (damped) Hooke's law for each spring
    for (int i = clothHeight*stringColumn + clothHeight-1; i > clothHeight*stringColumn; i--){
      Vec3 diff = clothVertices.get(i-1).position.minus(clothVertices.get(i).position);
      float stringF = -k*(diff.length() - restLength);
      
      Vec3 stringDir = diff.normalized();
      float projVbot = dot(clothVertices.get(i).velocity, stringDir);
      float projVtop = dot(clothVertices.get(i-1).velocity, stringDir);
      float dampF = -kv*(projVtop - projVbot);
      
      Vec3 force = stringDir.times(stringF+dampF);
      //clothVertices.get(i).acceleration.add(force.times(-1.0/mass));
      //clothVertices.get(i-1).acceleration.add(force.times(1.0/mass));
      clothVertices.get(i).force = clothVertices.get(i).force.plus(force.times(-1.0/mass));
      clothVertices.get(i-1).force = clothVertices.get(i-1).force.plus(force.times(1.0/mass));
    }
  }
    
  //horizontal interaction left moves with right
  for (int stringRow = 1; stringRow < clothHeight - 1; stringRow++){
    //Compute (damped) Hooke's law for each spring
    for (int i = clothLength*stringRow; i < clothLength*stringRow + clothLength; i++){
      Vec3 diff = clothVertices.get(i+clothHeight).position.minus(clothVertices.get(i).position);
      float stringF = -hor_k*(diff.length() - horizontalRestLenght);
      
      Vec3 stringDir = diff.normalized();
      float projVbot = dot(clothVertices.get(i).velocity, stringDir);
      float projVtop = dot(clothVertices.get(i+clothHeight).velocity, stringDir);
      float dampF = -hor_kv*(projVtop - projVbot);
      
      Vec3 force = stringDir.times(stringF+dampF);
      //clothVertices.get(i).acceleration.add(force.times(-1.0/mass));
      //clothVertices.get(i+clothHeight).acceleration.add(force.times(1.0/mass));
      clothVertices.get(i).force = clothVertices.get(i).force.plus(force.times(-1.0/mass));
      clothVertices.get(i+clothHeight).force = clothVertices.get(i+clothHeight).force.plus(force.times(1.0/mass));
    }
  }
  //horizontal interaction right moves with left
  for (int stringRow = clothHeight; stringRow > 1; stringRow--){
    //Compute (damped) Hooke's law for each spring
    for (int i = clothLength*stringRow - 1; i > clothLength*stringRow - clothLength; i--){
      Vec3 diff = clothVertices.get(i-clothHeight).position.minus(clothVertices.get(i).position);
      float stringF = -hor_k*(diff.length() - horizontalRestLenght);
      
      Vec3 stringDir = diff.normalized();
      float projVbot = dot(clothVertices.get(i).velocity, stringDir);
      float projVtop = dot(clothVertices.get(i-clothHeight).velocity, stringDir);
      float dampF = -hor_kv*(projVtop - projVbot);
      
      Vec3 force = stringDir.times(stringF+dampF);
      //clothVertices.get(i).acceleration.add(force.times(-1.0/mass));
      //clothVertices.get(i-clothHeight).acceleration.add(force.times(1.0/mass));
      clothVertices.get(i).force = clothVertices.get(i).force.plus(force.times(-1.0/mass));
      clothVertices.get(i-clothHeight).force = clothVertices.get(i-clothHeight).force.plus(force.times(1.0/mass));
    }
  }
  
  for(int i = 0; i < clothVertices.size(); i++){
    if (i != selected){
      clothVertices.get(i).acceleration.add(clothVertices.get(i).force);
    }
  }
  
  //Simplified friction (Coulomb model)
  for(int i = 0; i < clothVertices.size(); i++){
    Vec3 fauxfriction = clothVertices.get(i).velocity.times(frictionConstant);
    clothVertices.get(i).acceleration.add(fauxfriction);
  }
  //Eulerian integration
  for (int stringColumn = 0; stringColumn < clothLength; stringColumn++){
    for (int i = clothHeight*stringColumn + 1; i < clothHeight*stringColumn + clothHeight; i++){
      clothVertices.get(i).velocity.add(clothVertices.get(i).acceleration.times(dt));
      clothVertices.get(i).position.add(clothVertices.get(i).velocity.times(dt));
    }
  }
  
}



/*
  callback functions to handle user keyboard inputs
*/
boolean leftPressed, rightPressed, upPressed, downPressed, shiftPressed, change_y;
void keyPressed()
{
  if (key == 'g' || key == 'G') paused = !paused;
  if (key == 'y') change_y = true;
  if (keyCode == LEFT) leftPressed = true;
  if (keyCode == RIGHT) rightPressed = true;
  if (keyCode == UP) upPressed = true; 
  if (keyCode == DOWN) downPressed = true;
  if (keyCode == SHIFT) shiftPressed = true;
  
  camera.HandleKeyPressed();
}

void keyReleased()
{
  if (key == 'y') change_y = false;
  if (keyCode == LEFT) leftPressed = false;
  if (keyCode == RIGHT) rightPressed = false;
  if (keyCode == UP) upPressed = false; 
  if (keyCode == DOWN) downPressed = false;
  if (keyCode == SHIFT) shiftPressed = false;
  
  camera.HandleKeyReleased();
}

void mousePressed(){
  Vec3 mousePos = new Vec3(mouseX, mouseY,0);
  for (int i = 1; i < numVertices; i++){
    if (mousePos.distanceTo(clothVertices.get(i).position) < radius){
      selected = i;
    }
  }
}

void mouseDragged(){
  if (selected > 0){
    clothVertices.get(selected).position = new Vec3(mouseX, mouseY,0);
    clothVertices.get(selected).velocity = new Vec3(0,0,0);
    clothVertices.get(selected).acceleration = new Vec3(0, 0,0);
  }
}

void mouseReleased(){
  selected = -1;
}
