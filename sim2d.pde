import controlP5.*;

ControlP5 p5;

float g = 0.0, elast=1,friction=1,interelas=1; // Initialize gravity.
int substeps = 5;
float[] a = {100, 100, 100}; // RGB color values.
color col = color(200); // Create a color based on the RGB values.
float side = 20; // Set the size of the particle.
ArrayList<Float> pathx = new ArrayList<Float>(); // Create an array list to store x-coordinates of the path.
ArrayList<Float> pathy = new ArrayList<Float>(); // Create an array list to store y-coordinates of the path.
ArrayList<body> bodies = new ArrayList<body>(); // Create an array list to store body objects.

void setup() {
  p5=new ControlP5(this);
  size(1200, 700); // Set up the canvas size.
  
  addGUI(p5);
  for(int i=1;i<2000;i++){
    //bodies.add(new body(width/2, height/2, 0, 0, 1)); // Create a body object and add it to the array list.
    //bodies.get(bodies.size()-1).setGravity(true);
  }
  for (body b : bodies) {
    fill(b.c);
    b.setSize(random(15,80));
    circle(b.pos.x, b.pos.y, b.rad); // Display the particle on the canvas.
  }
}

void draw() {
  background(col); // Set the background color.
  disptext(bodies);
  if (mousePressed && !p5.isMouseOver()) {
    pathx.clear(); // Clear the x-coordinate path array.
    pathy.clear(); // Clear the y-coordinate path array.
    circle(mouseX, mouseY, side); // Display a circle at the current mouse position.
  }
  if(bodies.size()!=0){
    substep(substeps);
  
    for (body b : bodies) {
      
      fill(b.c);
      stroke(b.c);
      circle(b.pos.x, b.pos.y, b.rad); // Display the updated positions of the bodies.
    }
  
    drawpath(pathx, pathy); // Draw the path of the last body.
  }
}

color randomcolor() {
  float[] a = {random(0, 256), random(0, 256), random(0, 256)}; // Generate random RGB color values.
  return color(a[0], a[1], a[2]); // Create a color based on the random RGB values.
}

void drawpath(ArrayList<Float> x, ArrayList<Float> y) {
  for (int i = 0; i < x.size() - 1; i++) {
    line(x.get(i), y.get(i), x.get(i + 1), y.get(i + 1)); // Draw a line connecting path points.
  }
}

void motionupdate(ArrayList<body> bodies, float timeconst) {
  for (int i = 0; i < bodies.size(); i++) {
    bodies.get(i).setSize(side);
    bodies.get(i).v.y += g*timeconst; // Apply gravity to the vertical velocity.
    bodies.get(i).pos.add(PVector.mult(bodies.get(i).v,timeconst)); // Update the position.
  }
}

void wallColl(ArrayList<body> bodies) {
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
    if (b.pos.x > width - b.rad/2) {
      b.pos.x = width - b.rad/2; // Adjust position to prevent going beyond the right wall.
      b.v.x *= -elast; // Reverse horizontal velocity with some loss.
    }
    if (b.pos.y > height - b.rad/2) {
      b.v.x *= friction; // Reduce horizontal velocity near the bottom wall.
      b.pos.y = height - b.rad/2; // Adjust position to prevent going beyond the bottom wall.
      if (b.v.y < 0.5){
        b.v.y = 0; // Stop vertical motion if velocity is small.
      } 
      else
        b.v.y *= -elast; // Reverse vertical velocity with some loss.
      bodies.get(i).copyparams(b);
    }
  }
}

void mouseReleased() {
  if(!p5.isMouseOver()){
    pathx.clear(); // Clear the path arrays.
    pathy.clear();
    bodies.add(new body(mouseX, mouseY, (mouseX - pmouseX) * 0.2, (mouseY - pmouseY) * 0.2, 1)); // Add a new body with user input.
    int index=bodies.size()-1;
    bodies.get(index).setGravity(true);
    bodies.get(index).setSize(side);//random(15,80));
  }
}

void handleInterColl(ArrayList<body> bodies) {
  for (int i = 0; i < bodies.size() - 1; i++) {
    body b1 = bodies.get(i);
    for (int j = i + 1; j < bodies.size(); j++) {
      if (b1.checkCollision(bodies.get(j))) {
        body b2 = bodies.get(j);
        float cosr2 = cos(PVector.angleBetween(PVector.sub(b2.pos,b1.pos),b2.v));
        float cosr1 = cos(PVector.angleBetween(PVector.sub(b1.pos,b2.pos),b1.v));
        float impulse = -interelas*(b1.v.mag()*cosr1+b2.v.mag()*cosr2);
        float abc = PVector.dot(PVector.sub(b2.pos,b1.pos).normalize(),PVector.sub(b1.v,PVector.sub(b2.pos,b1.pos).normalize().mult(-b1.v.mag()*cosr1)));
        println(abc);
        if(abc>1)
          println(abc);
        b2.v.add(PVector.sub(b2.pos,b1.pos).normalize().mult(impulse));
        b1.v.sub(PVector.sub(b2.pos,b1.pos).normalize().mult(impulse));
        
        float dist = PVector.sub(b1.pos,b2.pos).mag()+0.0001;
        PVector shift = PVector.sub(b2.pos,b1.pos).mult((b1.rad/2+b2.rad/2)/dist-1.0).mult(0.5);
        b2.pos.add(shift);
        b1.pos.sub(shift);
        dist = PVector.sub(b2.pos,b1.pos).mag()+0.0001;
                
        bodies.get(j).copyparams(b2);
        bodies.get(i).copyparams(b1);
      }
    }
  }
}

void substep(int n){
  for(int i=1;i<=n;i++){
      handleInterColl(bodies); // Handle interactions between bodies.
      wallColl(bodies); // Handle collisions with walls.
    
      pathx.add(bodies.get(bodies.size() - 1).pos.x); // Add the x-coordinate of the last body to the path.
      pathy.add(bodies.get(bodies.size() - 1).pos.y); // Add the y-coordinate of the last body to the path.
      
      forceupdate(getforce(bodies)); //update attractive force
    
      motionupdate(bodies,1/(float)n); // Update the motion of bodies.
  }
}

void disptext(ArrayList<body> bod){
  float en=0;
  double vx=0,vy=0;
  if(bod.size()!=0){
    body bi=bod.get(bod.size()-1);
    vx=(int)(bi.v.x*100)/100d; vy=(int)(bi.v.y*100)/100d;
  }
  int count=0;
  
  for(body b:bod){
    en+=Math.sqrt(b.v.mag()*b.mass);
    count++;
  }
  fill(0);
  textSize(20);
  text("Count: "+count,0,20);
  text("Vx: "+vx,0,40);
  text("Vy: "+vy,0,60);
  text("Energy: "+en,0,80);
}

void forceupdate(PVector[] f){
  for(int i=0;i<bodies.size();i++){
    body b = bodies.get(i);
    try{
      b.v.add(f[i]);
    }
    catch(Exception e){}
    bodies.get(i).copyparams(b);
  }
}
