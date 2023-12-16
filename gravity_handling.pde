PVector[] getforce(ArrayList<body> bodies){
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
      float r = PVector.sub(b1.pos,b2.pos).mag() + 0.0001;
      //float fr = -fconst*b1.mass*b2.mass/(r*r);
      PVector fr = PVector.sub(b1.pos,b2.pos).mult(-fconst/(r*r));
      f[i].add(PVector.mult(fr,b1.mass));
      f[j].sub(PVector.mult(fr,b2.mass));
    }
   
  }
  return f;
}
