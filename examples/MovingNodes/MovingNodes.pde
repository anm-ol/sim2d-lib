import physics.sim2d.*;
ArrayList<body> group = new ArrayList<body>();
ArrayList<PVector> path= new ArrayList<PVector>();
Sim2d sim;
body b;
color bg = color(0);
boolean running=false,recording=false,spawning=false;
float rad=20;
void setup(){
  size(1200,800);
  sim = new Sim2d(this);
  sim.friction=1;
  sim.interelas=1;
  sim.elast=1;
  sim.n_substep = 1;
  sim.g=0;
}

void draw(){
  background(bg);
  if(mousePressed && !spawning)
  {
    spawning = true;
    running = false;
    b= new body(mouseX,mouseY,0,0,0);
    b.setSize(rad);
    sim.bodies.add(b);
  }
  else if(spawning){
    stroke(b.c);
    line(b.pos.x,b.pos.y,mouseX,mouseY);
  }
  if(running){
    path.add(sim.bodies.get(sim.bodies.size()-1).pos);
    sim.substep();
  }
  paintsim(sim);
  if(recording){
    saveFrame("output/simsim_####.png");
    fill(150,0,0);
    circle(width-40,50,30);
  }
}

void mouseReleased(){
  if(spawning){
    b.v = (new PVector(mouseX-b.pos.x,mouseY-b.pos.y)).mult(1/5f);
    sim.bodies.set(sim.bodies.size()-1,b);
    running = true;
    spawning = false;
  }
}
void keyPressed(){
  if(key == 'r' || key=='R')
    recording = !recording;
  if(key=='p' || key=='P')
    running = !running;
}

void paintsim(Sim2d sim){
  for(int i=0;i<sim.bodies.size();i++){
    body bb = sim.bodies.get(i);
    fill(bb.c);
    circle(bb.pos.x,bb.pos.y,bb.rad);
  }
  for(int i=1;i<path.size();i++){
    stroke(b.c);
    line(path.get(i-1).x,path.get(i-1).y,path.get(i).x,path.get(i).y);
  }
}
