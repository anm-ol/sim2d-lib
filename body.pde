class body{
  float mass;
  color c=color();
  boolean grav=false;
  float rad=side;
  PVector pos, v;
  
  body(float posx,float posy,float vx,float vy,float m){
    this.pos = new PVector(posx,posy);
    this.v = new PVector(vx,vy);
    this.mass=m;
  }
  
  void setGravity(boolean b){
    this.grav = false;
  }
  
  boolean checkCollision(body b){
    return (PVector.sub(this.pos,b.pos).magSq()-0.001 < Math.pow((this.rad/2+b.rad/2),2));
  }
  void setSize(float r){
   // r=1;
    this.rad=r;
    this.mass=r*(float)Math.pow(20,3)/400000;
  }
  void copyparams(body b){
    this.mass=b.mass;
    this.pos = b.pos;
    this.v = b.v;
  }
}
