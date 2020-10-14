/*

  CSCI 5611 - Project 2
  Authors: Jeffrey Jia and Jon-Michael Hoang
  Date: // insert due date here
  Desc: // description of the code

*/

Camera camera;

Vec3 gravity = new Vec3 (0, 10, 0);
float radius = 5;

// starting position
Vec3 stringTop = new Vec3(200, 100, 0);
//Vec3 restLength = new Vec3(0, 40, 0);
float restLength = 40;

float mass = 1;

// tuning parameters
float k = 20;
float kv = 1;

float frictionConstant = -0.5;

int stringSize = 10;
// row(column)
//ArrayList<ArrayList<Vec3>> clothVertexPositions = new ArrayList<ArrayList<Vec3>>();
//ArrayList<ArrayList<Vec3>> clothVelocities = new ArrayList<ArrayList<Vec3>>();

ArrayList <Vertex> clothVertices = new ArrayList <Vertex> ();

/*
  the int main() of Processing
*/
void setup()
{
  size (1024, 720, P3D);
  //camera = new Camera();
  
  // populate clothVertices with vertices with initial positions and velocities
  for (int i = 0; i < stringSize; i++)
  {
    Vec3 tempPosition = new Vec3(stringTop.x + i + 10, stringTop.y + i * 50, 0);
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
void draw()
{
  background(255, 255, 255);
  //camera.Update(1.0 / frameRate);
  
  update(.1);
  
  fill(0, 0, 255);
  
  for (int i = 0; i < clothVertices.size()-1; i++){
    pushMatrix();
    line(clothVertices.get(i).position.x,clothVertices.get(i).position.y,clothVertices.get(i+1).position.x,clothVertices.get(i+1).position.y);
    translate(clothVertices.get(i+1).position.x,clothVertices.get(i+1).position.y);
    sphere(radius);
    popMatrix();
  }
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
  //Reset accelerations each timestep (momenum only applies to velocity)
  for (int i = 0; i < clothVertices.size(); i++){
    clothVertices.get(i).acceleration = new Vec3(0,0,0);
    clothVertices.get(i).acceleration.add(gravity);
  }
  
  //Compute (damped) Hooke's law for each spring
  for (int i = 0; i < clothVertices.size()-1; i++){
    Vec3 diff = clothVertices.get(i+1).position.minus(clothVertices.get(i).position);
    float stringF = -k*(diff.length() - restLength);
    //println(stringF,diff.length(),restLen);
    
    Vec3 stringDir = diff.normalized();
    float projVbot = dot(clothVertices.get(i).velocity, stringDir);
    float projVtop = dot(clothVertices.get(i+1).velocity, stringDir);
    float dampF = -kv*(projVtop - projVbot);
    
    Vec3 force = stringDir.times(stringF+dampF);
    clothVertices.get(i).acceleration.add(force.times(-1.0/mass));
    clothVertices.get(i+1).acceleration.add(force.times(1.0/mass));
    
  }
  
  for (int i = 0; i < clothVertices.size(); i++){
    Vec3 fauxfriction = clothVertices.get(i).velocity.times(frictionConstant);
    clothVertices.get(i).acceleration.add(fauxfriction);
  }
  
  //Eulerian integration
  for (int i = 1; i < clothVertices.size(); i++){
    clothVertices.get(i).velocity.add(clothVertices.get(i).acceleration.times(dt));
    clothVertices.get(i).position.add(clothVertices.get(i).velocity.times(dt));
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
  //camera.HandleKeyPressed();
}

void keyReleased()
{
  //camera.HandleKeyPressed();
}
