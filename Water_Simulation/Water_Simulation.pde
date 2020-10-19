//1D Heat Equation : du/dt = k*(d2/dx2)u
//CSCI 5611 PDE Integration [Exercise]
// Stephen J. Guy <sjguy@umn.edu>
  
//TODO:
//  -Recall the heat equation says heat will change at a rate proportional to the 
//   laplacian, confirm that it is implemented correctly here.
//  -The laplacian of a function is given by how much the slope changes, show
//     that laplacian and laplacian_alt compute the same value.
//  -The function colorByTemp() takes in a temperature (expected to be between 0 and 1)
//     and calls fill with a color based on that temperature. Currently colorByTemp() is
//     grayscale, change it to follow a blackbody color ramp. This is:
//        -From 0 - 0.333, interpolate from black to red
//        -From 0.333 - 0.666, interpolate from red to yellow
//        -From 0.666 - 1.0, interpolate from yellow to white
//        -You can choose any color you like for outside to 0 to 1 range (or simply
//         clamp the input to be from 0 to 1).
//  -Currently, the temperature is not fixed on either end (free boundary conditions)
//     Set one end of the bar to always be a fixed temperature of 1.0.
//  -The Stefan–Boltzmann law of evaporative cooling states that heat in a vacuum will
//     dissipate by a rate proportional to heat^4. Add a Stefan–Boltzmann evaporative 
//     cooling term to the simulated used in the PDE.
//  -How does the final state of the system compare with a cooling rate k=0 vs k=1 vs k = 100

// Challenge:
//  -Reset the simulation when 'r' is pressed
//  -Allow the user to set hot spots using the mouse or keyboard
//  -Discuss why the weight factor alpha is multiplied by n
//  -Try midpoint integration, is it any more stable?

static int n = 20;
float dx = 400/n;
float dy = 40;
float heat[] = new float[n];
float dheat_dt[] = new float[n];
float alpha = 1000*n; 

float k = 50;

//Set up screen and initial conditions
String windowTitle = "Heatflow Simulation";
void setup(){
  size(600, 300);
  //Initial tepmapture distribution
  for (int i = 0; i < n; i++){ //TODO: Try different initial conditions
    heat[i] = i/(float)n;
  }
}

//TODO: Change me to a blackbody color ramp
void colorByTemp(float u){
  float r = u/1;
  float g = u/1;
  float b = u/1;
  fill(255*r,255*g,255*b);
}

//Red for positive values, blue for negative ones.
void redBlue(float u){
  if (u < 0)
    fill(0,0,-255*u);
  else
    fill(255*u,0,0);
}

void update(float dt){
  //Compute Gradiant of heat (du/dt = alpha*laplacian)
  for (int i = 1; i < n-1; i++){
    float leftGradient = (heat[i-1] - heat[i])/dx;
    float rightGradient = (heat[i] - heat[i+1])/dx;
    float laplacian = (leftGradient - rightGradient)/dx; 
    float lapalcianAlt = (heat[i-1] - 2*heat[i] + heat[i+1])/(dx*dx);
    dheat_dt[i] = alpha * laplacian;
    //TODO: Add evaporative cooling here
  }
  
  //Impose (free) Bounardy Conditions
  heat[0] = heat[1];
  heat[n-1] = heat[n-2];
  dheat_dt[0] = dheat_dt[1];
  dheat_dt[n-1] = dheat_dt[n-2];
  
  //Integrate with Eulerian integration
  for (int i = 0; i < n; i++){
    heat[i] += dheat_dt[i]*dt;
  }
}

boolean paused = true;
void draw() {
  background(200,200,200);
  
  float dt = 0.0002;
  for (int i = 0; i < 20; i++){
    if (!paused) update(dt);
  }
    
  //Draw Heat
  fill(0);
  text("Heat:", 50, 105);
  noStroke();
  for (int i = 0; i < n; i++){
    colorByTemp(heat[i]);
    pushMatrix();
    translate(100+dx*i,100+0);
    beginShape();
    vertex(-dx/2, -dy/2);
    vertex(dx/2, -dy/2);
    vertex(dx/2, dy/2);
    vertex(-dx/2, dy/2);
    endShape();
    popMatrix();
  }
  noFill();
  stroke(1);
  rect(100-dx/2,100-dy/2,n*dx,dy);
  
  //Draw derivative (dHeat/dt)
  fill(0);
  text("Derivative:", 22, 205);
  noStroke();
  for (int i = 0; i < n; i++){
    redBlue(4*dheat_dt[i]);
    pushMatrix();
    translate(100+dx*i,200+0);
    beginShape();
    vertex(-dx/2, -dy/2);
    vertex(dx/2, -dy/2);
    vertex(dx/2, dy/2);
    vertex(-dx/2, dy/2);
    endShape();
    popMatrix();
  }
  noFill();
  stroke(1);
  rect(100-dx/2,200-dy/2,n*dx,dy);
  
  if (paused)
    surface.setTitle(windowTitle + " [PAUSED]");
  else
    surface.setTitle(windowTitle + " "+ nf(frameRate,0,2) + "FPS");
}

void keyPressed(){
  paused = !paused;
}
