import physics.sim2d.*;
ArrayList<body> group = new ArrayList<body>();
Sim2d sim;
color bg = color(0);
boolean startsim=false;
float rad=5,maxrad=15;
void setup(){
  size(1000,800);
  sim = new Sim2d(this);
  sim.friction=0.95;
  sim.interelas=0.95;
  sim.elast=0.85;
  sim.n_substep = 15;
  sim.g=.3f;
}

void draw(){
  background(bg);
  if(mousePressed){
    startsim=false;
    group.add(new body(mouseX,mouseY,0,0,0));
    sim.bodies=group;
    sim.bodies.get(sim.bodies.size()-1).setSize(random(rad,maxrad));
    sim.handleInterColl(sim.bodies);
    paintsim(sim);
  }
  if(startsim){
    paintsim(sim);
    sim.substep();
  }
}

void mouseReleased(){
  sim.bodies = group;
  startsim = true;
}

void paintsim(Sim2d sim){
  for(int i=0;i<sim.bodies.size();i++){
    body bb = sim.bodies.get(i);
    fill(bb.c);
    circle(bb.pos.x,bb.pos.y,bb.rad);
  }
}
