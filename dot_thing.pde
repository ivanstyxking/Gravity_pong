int bagels = 0;
void dots(){
  for(int i=0;i<=100;i++){
    strokeWeight(1);
    point(random(0,width),height/2+30*randomGaussian()+200*sin(radians(bagels)));
    point(random(0,width),height/2+10*randomGaussian()+300*cos(radians(2*bagels)));
     point(random(0,width),height/2+20*randomGaussian()+100*sin(radians(0.5*bagels)));
  }
  bagels++;
}
