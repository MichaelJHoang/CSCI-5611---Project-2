// number of partitions
static int n = 20;
// how large the entire bar is
float dx = 400/n;
// how tall the entire bar is
float dy = 40; 

// update h and hu using numerical integration
float h[] = new float[n];
float hu[] = new float[n]; // height * velocity momentum hv

float dhdt[] = new float[n]; // height (midpoint)
float dhdt_mid[] = new float[n]; // momentum (midpoint)

float dhudt[] = new float[n]; // momentum (midpoint)
float dhudt_mid[] = new float[n]; // momentum (midpoint)

float h_mid[] = new float[n];
float hu_mid[] = new float[n];

float dhudx = 0, dhudx_mid = 0;
float dhu2dx = 0, dhu2dx_mid = 0;
float dgh2dx = 0, dgh2dx_mid = 0;

float gravity = 9.81;
float damp = 0.9;

boolean paused = true;

//Set up screen and initial conditions
String windowTitle = "1D Shallow Water Simulation";

void setup()
{
  size(600, 300);
}





//TODO: Change me to a blackbody color ramp
void colorByTemp(float u){
  float r = u/1;
  float g = u/1;
  float b = u/1;
  fill(255*r,255*g,255*b);
}





//Red for positive values, blue for negative ones.
void accountWaterColor(float u){
  if (u < 0)
    fill(0,0,-255*u);
  else
    fill(0,0,255*u);
}





/*
  Each frame:
    1. Compute the midpoints of h and hu
    2. Computer SWE PDEs using midpoints
    3. Update midpoints 1/2 timestep (Eulerian)
    4. Compute SWE PDEs using updates midpoints
    5. Update h and hu full timestep (Eulerian)
*/
void update(float dt)
{
  // compute midpoint heights and momentums
  for (int x = 1; x < n - 1; x++)
  {
    // midpoint method
    h_mid[x] = (h[x + 1] + h[x]) / 2;
    hu_mid[x] = (hu[x + 1] + hu[x]) / 2;
    
    // midpoint partial
    // compute dh/dt (mid)
    dhudx_mid = (hu[x + 1] - hu[x]) / dx;
    dhdt_mid[x] = -dhudx_mid;
    
    //compute dhu/dt (mid)
    dhu2dx_mid = (sq(hu[x + 1]) / h[x + 1] - sq(hu[x]) / h[x]) / dx;
    dgh2dx_mid = gravity * (sq(h[x + 1]) - sq(h[x])) / dx;
    dhudt_mid[x] = -(dhu2dx_mid + .5 * dgh2dx_mid);
    
    // midpoint update
    // integrate midpoint
    h_mid[x] += dhdt_mid[x] * dt / 2;
    hu_mid[x] += dhudt_mid[x] * dt/2;
    
    // partials
    // compute dh/dt (mid)
    dhudx = (hu_mid[x] - hu_mid[x - 1]) / dx;
    dhdt[x] = -dhudx;
    
    //compute dhu/dt (mid)
    dhu2dx = (sq(hu_mid[x]) / h_mid[x] - sq(hu_mid[x - 1]) / h_mid[x - 1]) / dx;
    dgh2dx = gravity * (sq(h_mid[x]) - sq(h_mid[x - 1])) / dx;
    dhudt[x] = -(dhu2dx + .5 * dgh2dx);
    
    // integrate heights and momentum
    h[x] += damp* dhdt[x] * dt;
    hu[x] += damp * dhudt[x] * dt;
  }
  
  // handle boundry conditions
  h[0] = h[n - 2];
  h[n-1] = h[1];
  hu[0] = hu[n - 2];
  hu[n - 1] = hu[1];
}





void draw() 
{
  background(194, 178, 128);
  
  float dt = 0.01;
  float simulation_dt = 0.001;
  for (int i = 0; i < int(dt / simulation_dt); i++)
  {
    if (!paused)
    {
      update(dt);
    }
  }
   
  
  //1D water
  for (int i = 0; i < n; i++)
  {
    System.out.println(h[i]);
    accountWaterColor(hu[i]);
    
    pushMatrix();
    
      translate(100+dx*i,150+0);
      
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
  rect(100-dx/2,150-dy/2,n*dx,dy);
  
  if (paused)
    surface.setTitle(windowTitle + " [PAUSED]");
  else
    surface.setTitle(windowTitle + " "+ nf(frameRate,0,2) + "FPS");
}

void keyPressed()
{
  paused = !paused;
}
