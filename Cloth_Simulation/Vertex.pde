public class Vertex
{
  
  Vec3 position = new Vec3();
  Vec3 velocity = new Vec3();
  Vec3 acceleration = new Vec3();
  Vec3 stringForce = new Vec3();
  Vec3 dampForce = new Vec3();
  Vec3 force = new Vec3();
  Boolean broken = false;

  
  public Vertex(Vec3 position, Vec3 velocity, Vec3 acceleration, Vec3 stringForce, Vec3 dampForce, Vec3 force, Boolean broken)
  {
    this.position = position;
    this.velocity = velocity;
    this.acceleration = acceleration;
    
    this.stringForce = stringForce;
    this.dampForce = dampForce;
    this.force = force;
    this.broken = broken;
  }
  
  public Vertex()
  {
  }
}
