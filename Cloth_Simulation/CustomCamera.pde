public class CustomCamera
{
  // camera movements
  // based on ship movements
  // see: https://www.researchgate.net/profile/Roy_De_Winter/publication/327838620/figure/fig5/AS:674344674000900@1537787707747/4-Roll-pitch-yaw-heave-sway-surge-of-a-ship.ppm
  // would use camera based movements, but they were a bit more confusing than ship movements
  // see: https://embedwistia-a.akamaihd.net/deliveries/6e58ced2a25d41014910ae9f710f41d3.webp?image_crop_resized=1280x720
  PVector surge = new PVector (0.0f, 0.0f, -1.0f), sway;
  float yaw = -90.f, pitch = 0.0f, speed = 25.0f;
  
  // camera orientations
  PVector position, vup, worldUp = new PVector(0.0f, 1.0f, 0.0f);
  float zoom = 45.0f;
  
  // constructor to position the initial position of the camera
  CustomCamera(PVector position)
  {
    this.position = position;
    
    this.updateCamera();
  }
  
  void updateCamera()
  {
    surge = new PVector(cos(radians(yaw)) * cos(radians(pitch)),
                        sin(radians(pitch)),
                        sin(radians(yaw)) * cos(radians(pitch)));
                        
    surge = surge.normalize();
    
    sway = surge.cross(worldUp).normalize();
    vup = sway.cross(surge).normalize();
  }
  
  void handleKeyPressed(float dt)
  {
    if (key == 'w' || key == 'W')
      position = new PVector(position.x + (surge.x * speed * dt), 
                             position.y + (surge.y * speed * dt), 
                             position.z + (surge.z * speed * dt));
    if (key == 's' || key == 'S')
      position = new PVector(position.x - (surge.x * speed * dt), 
                             position.y - (surge.y * speed * dt), 
                             position.z - (surge.z * speed * dt));
    if (key == 'a' || key == 'A')
      position = new PVector(position.x - (sway.x * speed * dt), 
                             position.y - (sway.y * speed * dt), 
                             position.z - (sway.z * speed * dt));
    if (key == 'd' || key == 'D')
      position = new PVector(position.x + (sway.x * speed * dt), 
                             position.y + (sway.y * speed * dt), 
                             position.z + (sway.z * speed * dt));
  }
}
