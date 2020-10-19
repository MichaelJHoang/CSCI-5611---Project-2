/*

  CSCI 5611 - Project 2
  Authors: Jeffrey Jia and Jon-Michael Hoang
  Date: // insert due date here
  Desc: // description of the code

*/

Camera camera;

Vec3 gravity = new Vec3 (0, 400, 0);
float radius = 5;

// starting position
Vec3 stringTop = new Vec3(200, 50, 0);
//Vec3 restLength = new Vec3(0, 40, 0);
float restLength = 10;

float mass = 0.3;

// tuning parameters
float k = 40;
float kv = 15;

float frictionConstant = -0.8;

int clothLength = 15;
int clothHeight = 15;
int numVertices = clothLength * clothHeight;
// row(column)
//ArrayList<ArrayList<Vec3>> clothVertexPositions = new ArrayList<ArrayList<Vec3>>();
//ArrayList<ArrayList<Vec3>> clothVelocities = new ArrayList<ArrayList<Vec3>>();

ArrayList <Vertex> clothVertices = new ArrayList <Vertex> ();

int selected = -1;
/*
  the int main() of Processing
*/
String windowTitle = "Swinging Rope";
void setup()
{
  size (1024, 720, P3D);
  surface.setTitle(windowTitle);
  //camera = new Camera();
  
  // populate clothVertices with vertices with initial positions and velocities
  
  for (int i = 0; i < clothLength; i++)
    for (int j = 0; j < clothHeight; j++)
    {
      Vec3 tempPosition = new Vec3(stringTop.x + i * 30 + j * 10, stringTop.y + j * 50, 0);
      Vec3 tempVelocity = new Vec3(0, 0, 0);
      Vertex tempVertex = new Vertex(tempPosition, tempVelocity, new Vec3(), new Vec3(), new Vec3(), new Vec3());
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
  background(255, 255, 255);
  //camera.Update(1.0 / frameRate);
  
  //update(.1);
  if (!paused) {
    for (int f = 0; f < 20; f++){
      update(1/(20*frameRate));
    }
  }
  
  fill(0, 0, 255);
  
  // First String
  pushMatrix();
  translate(clothVertices.get(clothHeight*0).position.x,clothVertices.get(clothHeight*0).position.y);
  //sphere(radius);
  point(0,0);
  popMatrix();
  for (int i = clothHeight*0; i < clothHeight*0 + clothHeight - 1; i++){
    pushMatrix();
    line(clothVertices.get(i).position.x,clothVertices.get(i).position.y,clothVertices.get(i+1).position.x,clothVertices.get(i+1).position.y);
    translate(clothVertices.get(i+1).position.x,clothVertices.get(i+1).position.y);
    //sphere(radius);
    point(0,0);
    popMatrix();
  }

  for (int stringColumn = 1; stringColumn < clothLength; stringColumn++){
    pushMatrix();
    translate(clothVertices.get(clothHeight*stringColumn).position.x,clothVertices.get(clothHeight*stringColumn).position.y);
    //sphere(radius);
    point(0,0);
    popMatrix();
    for (int i = clothHeight*stringColumn; i < clothHeight*stringColumn + clothHeight - 1; i++){
      pushMatrix();
      line(clothVertices.get(i).position.x,clothVertices.get(i).position.y,
           clothVertices.get(i+1).position.x,clothVertices.get(i+1).position.y);
      line(clothVertices.get(i).position.x,clothVertices.get(i).position.y,
           clothVertices.get(i - clothHeight).position.x,clothVertices.get(i - clothHeight).position.y);
      line(clothVertices.get(i).position.x,clothVertices.get(i).position.y,
           clothVertices.get(i+1 - clothHeight).position.x,clothVertices.get(i+1 - clothHeight).position.y);
      if(i != clothHeight*stringColumn){
        line(clothVertices.get(i).position.x,clothVertices.get(i).position.y,
           clothVertices.get(i-1 - clothHeight).position.x,clothVertices.get(i-1 - clothHeight).position.y);
      }
      translate(clothVertices.get(i+1).position.x,clothVertices.get(i+1).position.y);
      //sphere(radius);
      point(0,0);
      popMatrix();
    }
    pushMatrix();
    line(clothVertices.get(clothHeight*stringColumn + clothHeight - 1).position.x,clothVertices.get(clothHeight*stringColumn + clothHeight - 1).position.y,
         clothVertices.get(clothHeight*stringColumn - 1).position.x,clothVertices.get(clothHeight*stringColumn - 1).position.y);
    line(clothVertices.get(clothHeight*stringColumn + clothHeight - 1).position.x,clothVertices.get(clothHeight*stringColumn + clothHeight - 1).position.y,
         clothVertices.get(clothHeight*stringColumn - 2).position.x,clothVertices.get(clothHeight*stringColumn - 2).position.y);
    popMatrix();
    
  }
  if (paused)
    surface.setTitle(windowTitle + " [PAUSED]");
  else
    surface.setTitle(windowTitle + " "+ nf(frameRate,0,2) + "FPS");
  //pushMatrix();
  //line(200, stringTop.y, 200, clothVertices.get(0).position.y);
  //translate(200, clothVertices.get(0).position.y);
  //sphere(radius);
  //popMatrix();
  
  //pushMatrix();
  //line(200,clothVertices.get(0).position.y, 200, clothVertices.get(1).position.y);
  //translate(200, clothVertices.get(1).position.y);
  //sphere(radius);
  //popMatrix();
  
  //pushMatrix();
  //line(200,clothVertices.get(1).position.y, 200, clothVertices.get(2).position.y);
  //translate(200, clothVertices.get(2).position.y);
  //sphere(radius);
  //popMatrix();
}



/*
  update function to handle simulation code?
*/
void update(float dt)
{ 
  for (int stringColumn = 0; stringColumn < clothLength; stringColumn++){
    //Reset accelerations each timestep (momenum only applies to velocity)
    for (int i = clothHeight*stringColumn; i < clothHeight*stringColumn + clothHeight; i++){
      clothVertices.get(i).acceleration = new Vec3(0,0,0);
      clothVertices.get(i).acceleration.add(gravity);
    }
    
    //vertical interaction
    //Compute (damped) Hooke's law for each spring
    for (int i = clothHeight*stringColumn; i < clothHeight*stringColumn + clothHeight - 1; i++){
      Vec3 diff = clothVertices.get(i+1).position.minus(clothVertices.get(i).position);
      float stringF = -k*(diff.length() - restLength);
      
      Vec3 stringDir = diff.normalized();
      float projVbot = dot(clothVertices.get(i).velocity, stringDir);
      float projVtop = dot(clothVertices.get(i+1).velocity, stringDir);
      float dampF = -kv*(projVtop - projVbot);
      
      Vec3 force = stringDir.times(stringF+dampF);
      clothVertices.get(i).acceleration.add(force.times(-1.0/mass));
      clothVertices.get(i+1).acceleration.add(force.times(1.0/mass));
      
    }
    
    //Simplified friction (Coulomb model)
    for (int i = clothHeight*stringColumn; i < clothHeight*stringColumn + clothHeight; i++){
      Vec3 fauxfriction = clothVertices.get(i).velocity.times(frictionConstant);
      clothVertices.get(i).acceleration.add(fauxfriction);
    }
    
    //Eulerian integration
    for (int i = clothHeight*stringColumn + 1; i < clothHeight*stringColumn + clothHeight; i++){
      clothVertices.get(i).velocity.add(clothVertices.get(i).acceleration.times(dt));
      clothVertices.get(i).position.add(clothVertices.get(i).velocity.times(dt));
    }
  }
 
 
 
 
  //// first, second, and third
  //clothVertices.get(0).stringForce = (( clothVertices.get(0).position.minus(stringTop).minus(restLength))).times(-k);
  //clothVertices.get(0).dampForce = clothVertices.get(0).velocity.times(-kv);
  //clothVertices.get(0).force = clothVertices.get(0).stringForce.plus(clothVertices.get(0).dampForce);
  
  //for (int x = 1; x < clothVertices.size(); x++)
  //{
  //  clothVertices.get(x).stringForce = (( clothVertices.get(x).position.minus(clothVertices.get(x - 1).position).minus(restLength))).times(-k);
  //  clothVertices.get(x).dampForce = clothVertices.get(x).velocity.minus(clothVertices.get(x - 1).velocity).times(-kv);
  //  clothVertices.get(x).force = clothVertices.get(x).stringForce.plus(clothVertices.get(x).dampForce);
  //}
  
  //for (int x = clothVertices.size() - 1; x >= 0; x--)
  //{
  //  Vec3 combinedForce = clothVertices.get(x).force;
    
  //  for (int y = x; y < clothVertices.size(); y++)
  //  {
  //    combinedForce = combinedForce.minus(clothVertices.get(y).force);
  //    print(combinedForce);
  //  }
    
  //  clothVertices.get(x).acceleration = gravity.plus(combinedForce.times(1/mass));
  //  clothVertices.get(x).velocity = clothVertices.get(x).velocity.plus(clothVertices.get(x).acceleration.times(dt));
  //  clothVertices.get(x).position = clothVertices.get(x).position.plus(clothVertices.get(x).velocity.times(dt));
  //}
}



/*
  callback functions to handle user keyboard inputs
*/

void keyPressed()
{
  if (key == ' ')
    paused = !paused;
  //camera.HandleKeyPressed();
}

void keyReleased()
{
  //camera.HandleKeyPressed();
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
  }
}

void mouseReleased(){
  selected = -1;
}
