/*

  CSCI 5611 - Project 2
  Authors: Jeffrey Jia and Jon-Michael Hoang
  Date: // insert due date here
  Desc: // description of the code

*/

Camera camera;

float gravity = 9.81;
float radius = 10;
float stringTop = 50;
float restLength = 40;
float mass = 30;
float k = 20;
float kv = 10;

ArrayList<Vec3> clothVertexPositions = new ArrayList<Vec3>();
ArrayList<Vec3> clothVelocities = new ArrayList<Vec3>();


/*
  the int main() of Processing
*/
void setup()
{
  size (1024, 720, P3D);
  camera = new Camera();
}



/*
  function to draw based on the simulation code
*/
void draw()
{
  background(255);
  camera.Update(1.0 / frameRate);
}



/*
  update function to handle simulation code?
*/
void update()
{
}



/*
  callback functions to handle user keyboard inputs
*/
void keyPressed()
{
  camera.HandleKeyPressed();
}

void keyReleased()
{
  camera.HandleKeyPressed();
}
