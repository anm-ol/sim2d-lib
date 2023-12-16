package physics.sim2d;

import processing.core.*;
import java.util.ArrayList;


public class Sim2d {
	
	public PApplet p = new PApplet();
	
	public float g , elast,friction,interelas; // Initialize gravity.
	public int n_substep;
	public float h,w;
	public int col = p.color(200); // Create a color based on the RGB values.
	public float side; // Set the size of the particle.
	public ArrayList<body> bodies = new ArrayList<body>(); // Create an array list to store body objects.
	
	public Sim2d(PApplet parent) {
		p = parent;
		g = 0.0f;
		elast=1;
		friction=1;
		interelas=1;
		n_substep = 1;
	}
	
	public Sim2d(ArrayList<body> bodies) {
		this.bodies = bodies;

		g = 0.0f;
		elast=1;
		friction=1;
		interelas=1;
		n_substep = 1;
	}
	
	
	
	public void motionupdate(ArrayList<body> bodies, float timeconst) {
		  for (int i = 0; i < bodies.size(); i++) {
		    bodies.get(i).v.y += g*timeconst; // Apply gravity to the vertical velocity.
		    bodies.get(i).pos.add(PVector.mult(bodies.get(i).v,timeconst)); // Update the position.
		  }
		}
	
	public void handleInterColl(ArrayList<body> bodies) {
		  for (int i = 0; i < bodies.size() - 1; i++) {
		    body b1 = bodies.get(i);
		    for (int j = i + 1; j < bodies.size(); j++) {
		      if (b1.checkCollision(bodies.get(j))) {
		        body b2 = bodies.get(j);
		        float cosr2 = PApplet.cos(PVector.angleBetween(PVector.sub(b2.pos,b1.pos),b2.v));
		        float cosr1 = PApplet.cos(PVector.angleBetween(PVector.sub(b1.pos,b2.pos),b1.v));
		        float impulse = -interelas*(b1.v.mag()*cosr1+b2.v.mag()*cosr2);
		        //float abc = PVector.dot(PVector.sub(b2.pos,b1.pos).normalize(),PVector.sub(b1.v,PVector.sub(b2.pos,b1.pos).normalize().mult(-b1.v.mag()*cosr1)));
		       
		        b2.v.add(PVector.sub(b2.pos,b1.pos).normalize().mult(impulse));
		        b1.v.sub(PVector.sub(b2.pos,b1.pos).normalize().mult(impulse));
		        
		        float dist = PVector.sub(b1.pos,b2.pos).mag()+0.0001f;
		        PVector shift = PVector.sub(b2.pos,b1.pos).mult((b1.rad/2+b2.rad/2)/dist-1.0f).mult(0.5f);
		        b2.pos.add(shift);
		        b1.pos.sub(shift);
		        dist = PVector.sub(b2.pos,b1.pos).mag()+0.0001f;
		                
		        bodies.get(j).copyparams(b2);
		        bodies.get(i).copyparams(b1);
		      }
		    }
		  }
		}
	
	public void substep() {
		for(int i=1;i<=n_substep;i++){
		      handleInterColl(bodies); // Handle interactions between bodies.
		      wallColl(bodies); // Handle collisions with walls.
		      
		      forceupdate(getforce(bodies)); //update attractive force
		    
		      motionupdate(bodies,1/(float)n_substep); // Update the motion of bodies.
		  }
	}
	
	
	public void wallColl(ArrayList<body> bodies) {
		  for (int i = 0; i < bodies.size(); i++) {
		    body b = bodies.get(i);
		    if (b.pos.x < b.rad/2) {
		      b.pos.x = b.rad/2; // Adjust position to prevent going beyond the left wall.
		      b.v.x *= -elast; // Reverse horizontal velocity with some loss.
		    }
		    if (b.pos.y <= b.rad/2) {
		      b.pos.y = b.rad/2; // Adjust position to prevent going beyond the top wall.
		      b.v.y *= -elast; // Reverse vertical velocity with some loss.
		    }
		    if (b.pos.x > p.width - b.rad/2) {
		      b.pos.x = p.width  - b.rad/2; // Adjust position to prevent going beyond the right wall.
		      b.v.x *= -elast; // Reverse horizontal velocity with some loss.
		    }
		    if (b.pos.y > p.height - b.rad/2) {
		      b.v.x *= friction; // Reduce horizontal velocity near the bottom wall.
		      b.pos.y = p.height - b.rad/2; // Adjust position to prevent going beyond the bottom wall.
		      if (b.v.y < 0.5){
		        b.v.y = 0; // Stop vertical motion if velocity is small.
		      } 
		      else
		        b.v.y *= -elast; // Reverse vertical velocity with some loss.
		      bodies.get(i).copyparams(b);
		    }
		  }
		}
	
	
	public void forceupdate(PVector[] f){
		  for(int i=0;i<bodies.size();i++){
		    body b = bodies.get(i);
		    try{
		      b.v.add(f[i]);
		    }
		    catch(Exception e){}
		    bodies.get(i).copyparams(b);
		  }
		}
	
	public static PVector[] getforce(ArrayList<body> bodies){
		  PVector[] f = new PVector[bodies.size()];
		  int i=0;
		   while(i<f.length){
		    f[i] = new PVector(0,0);
		    i++;
		   }
		  final float fconst=100;
		  for(i=0;i<bodies.size()-1;i++)
		  {
		    body b1 = bodies.get(i);
		    if(!b1.grav)
		      {
		        continue;
		      }
		    for(int j=i;j<bodies.size();j++){
		      body b2 = bodies.get(j);
		      if(!b2.grav)
		        continue;
		      float r = PVector.sub(b1.pos,b2.pos).mag() + 0.0001f;
		      PVector fr = PVector.sub(b1.pos,b2.pos).mult(-fconst/(r*r));
		      f[i].add(PVector.mult(fr,b1.mass));
		      f[j].sub(PVector.mult(fr,b2.mass));
		    }
		   
		  }
		  return f;
		}

}

