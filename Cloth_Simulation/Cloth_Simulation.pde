/*

  CSCI 5611 - Project 2
  Authors: Jeffrey Jia and Jon-Michael Hoang
  Date: // insert due date here
  Desc: // description of the code

*/

Camera camera;

Vec3 gravity = new Vec3 (0, 9.81, 0);
float radius = 1;

// starting position
Vec3 stringTop = new Vec3(0, 50, 0);
Vec3 restLength = new Vec3(0, 40, 0);


float mass = 1;

// tuning parameters
float k = 20;
float kv = 10;

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
  for (int x = 0; x < 3; x++)
  {
    Vec3 tempPosition = new Vec3(0, 200 + x * 50, 0);
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
  
  pushMatrix();
  line(200, stringTop.y, 200, clothVertices.get(0).position.y);
  translate(200, clothVertices.get(0).position.y);
  sphere(radius);
  popMatrix();
  
  pushMatrix();
  line(200,clothVertices.get(0).position.y, 200, clothVertices.get(1).position.y);
  translate(200, clothVertices.get(1).position.y);
  sphere(radius);
  popMatrix();
  
  pushMatrix();
  line(200,clothVertices.get(1).position.y, 200, clothVertices.get(2).position.y);
  translate(200, clothVertices.get(2).position.y);
  sphere(radius);
  popMatrix();
}



/*
  update function to handle simulation code?
*/
void update(float dt)
{
  // first, second, and third
  clothVertices.get(0).stringForce = (( clothVertices.get(0).position.minus(stringTop).minus(restLength))).times(-k);
  clothVertices.get(0).dampForce = clothVertices.get(0).velocity.times(-kv);
  clothVertices.get(0).force = clothVertices.get(0).stringForce.plus(clothVertices.get(0).dampForce);
  
  for (int x = 1; x < clothVertices.size(); x++)
  {
    clothVertices.get(x).stringForce = (( clothVertices.get(x).position.minus(clothVertices.get(x - 1).position).minus(restLength))).times(-k);
    clothVertices.get(x).dampForce = clothVertices.get(x).velocity.minus(clothVertices.get(x - 1).velocity).times(-kv);
    clothVertices.get(x).force = clothVertices.get(x).stringForce.plus(clothVertices.get(x).dampForce);
  }
  
  for (int x = clothVertices.size() - 1; x >= 0; x--)
  {
    Vec3 combinedForce = clothVertices.get(x).force;
    
    for (int y = x; y < clothVertices.size(); y++)
    {
      combinedForce = combinedForce.minus(clothVertices.get(y).force);
    }
    
    clothVertices.get(x).acceleration = gravity.plus( combinedForce.times(1 / mass));
    clothVertices.get(x).velocity = clothVertices.get(x).velocity.plus(clothVertices.get(x).acceleration.times(dt));
    clothVertices.get(x).position = clothVertices.get(x).position.plus(clothVertices.get(x).velocity.times(dt));
  }
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
