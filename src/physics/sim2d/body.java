package physics.sim2d;

//import processing.*;
import processing.core.*;

public class body{
	  public float mass;

	  public static PApplet p = new PApplet();
	  public int c= randomcolor();
	  public boolean grav=false;
	  public float rad;
	  public PVector pos, v;
	  
	  public body(float posx,float posy,float vx,float vy,float m){
	    this.pos = new PVector(posx,posy);
	    this.v = new PVector(vx,vy);
	    this.mass=m;
	  }
	  
	  public void setGravity(boolean b){
	    this.grav = b;
	  }
	  
	  public boolean checkCollision(body b){
	    return (PVector.sub(this.pos,b.pos).magSq()-0.001 < Math.pow((this.rad/2+b.rad/2),2));
	  }
	  public void setSize(float r){
	   // r=1;
	    this.rad=r;
	    this.mass=r*(float)Math.pow(20,3)/400000;
	  }
	  public void copyparams(body b){
	    this.mass=b.mass;
	    this.pos = b.pos;
	    this.v = b.v;
	  }
	  
	  public static int randomcolor() {
		  float[] a = {p.random(0,256), p.random(0, 256), p.random(0, 256)}; // Generate random RGB color values.
		  return p.color(a[0], a[1], a[2]); // Create a color based on the random RGB values.
		}
	}
