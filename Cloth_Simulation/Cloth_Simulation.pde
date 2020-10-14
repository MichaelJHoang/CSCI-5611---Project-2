/*

  CSCI 5611 - Project 2
  Authors: Jeffrey Jia and Jon-Michael Hoang
  Date: // insert due date here
  Desc: // description of the code

*/

Camera camera;



/*
  the int main() of Processing
*/
void setup()
{
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
