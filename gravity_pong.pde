float x = 0; //declare vars
float y = 0;
float speed = 0;
float xspeed = 4;
float GRAV = 0.5;
float batx = 0;
float recw = 200;
float m2b;
float m2e;
float b2b;
int score = 0;
int record = 0;
int fails = 0;
float vel;
PFont f;
PFont d;
PFont title;
boolean debug = false;
float positionX[] = new float[2];
float positionY[] = new float[2];
float xadd;
float yadd;
float xpredict;
boolean display;
boolean moved = false;
float u;
float frames;
float maxv;//(v-u)/a
int mul=0;
int alphaVal1 = 255;
int alphaVal2;
boolean hit = true;
boolean click = false;
PrintWriter output;
void setup() {
  frame.setTitle("Gravity Pong");
  size(800, 700);
  strokeWeight(4);
  stroke(0, 255, 0);
  f = createFont("Consolas", 14, true); //reference to createFont func
  d = createFont("Consolas", 14, true);
  title = createFont("Courier", 14, true);
  frameRate(61);
  smooth();
  background(0);
}
void draw() {
  background(0);
  menus();
  if (click) {
    background(0);
    fill(100, 255, 0, alphaVal1);
    textAlign(CENTER);
    textFont(title, 24);
    text("Welcome to Gravity Pong!", width/2, 40);
    textFont(title, 15);
    text("Move the mouse to start", width/2, 60);
    textFont(d, 10);
    textAlign(LEFT);
    fill(100, 255, 0, -255+2*alphaVal1);
    text("Control the surface to deflect the ball against gravity.", width/2-150, 80);
    text("As the ball speed increases, more points are awarded.", width/2-150, 90);
    text("press D to enter debug mode.", width/2-150, 100);
    textFont(title, 11);
    fill(200, 200, 200, alphaVal1);
    text("/*Programmed by Adrian King 2014", width-300, height-10);
    if (alphaVal1 > 0) {
      if (moved) {
        alphaVal1--;
      }
    }
    if (moved) {
      textFont(f, 17);                 
      fill(100, 255, 0);                        
      text("Your score: "+score, 10, 50);
      text("record: "+record, 10, 75);
      if (fails > 0) {
        text("fails: "+fails, 10, 100);
      }

      if (debug) {    //enter debug mode when d is pressed
        textFont(d, 11);
        fill(100, 255, 0);
        text("ball y = "+y, width-150, 30);
        text("ball x = "+x, width-150, 40);
        text("y vel = "+speed, width-150, 50);
        text("x vel = "+xspeed, width-150, 60);
        text("mouseX = "+mouseX, width-150, 70);
        text("mouseY = "+mouseY, width-150, 80);
        text("Gravity = "+GRAV, width-150, 90);
        text("ball |velocity| = "+vel, width-150, 100);
        text("x prediction: "+xpredict, width-150, 110);
        textFont(d, 20);
        text(int(frameRate)+" fps", width-150, 130);
        textFont(d, 11);
        m2b = sqrt((height-mouseY)*(height-mouseY)+(mouseX-batx)*(mouseX-batx));
        m2e = sqrt((y-mouseY)*(y-mouseY)+(mouseX-x)*(mouseX-x));
        b2b = sqrt((x-batx)*(x-batx)+(height-y)*(height-y));
        stroke(0, 125, 0);
        strokeWeight(1);
        line(x, y, mouseX, mouseY); //relative distances
        line(batx, height, mouseX, mouseY);
        line(batx, height, x, y);
        text(""+m2e, (x+mouseX)/2, (y+mouseY)/2);
        text(""+m2b, (batx+mouseX)/2, (height+mouseY)/2);
        text(""+b2b, (batx+x)/2, (height+y)/2);
        xadd = 10*(positionX[1]-positionX[0]);
        yadd = 10*(positionY[1]-positionY[0]);
        stroke(0, 255, 0);
        line(x, y, (positionX[1])+xadd, (positionY[1])+yadd);
        fill(100,255,0,150);
        if (display) {
          noStroke();
          ellipse(xpredict, height, 40, 30);
        }
        stroke(100,255,0);
        fill(100,255,0);
        HUD();
      }
      strokeWeight(4);
      noFill();
      ellipse(x, y, 20, 20);
      positionX[0] = x;
      positionY[0] = y;
      batx = (mouseX);
      if (batx <recw/2) {
        batx = recw/2;
      }
      if (batx > (width-recw/2)) {
        batx = width-recw/2;
      }
      if ((y > height)&&((x >= batx-recw/2)&&(x<=batx+recw/2))) { //check if ball has hit bat
        alphaVal2=255;
        hit=true;
        display = true;
        speed=speed*-1+1;
        y=height;
        bonus(xspeed);
        score = score +mul; //add to current score
        if (x<=batx-recw/4) { //determine xspeed reflections based on bat region
          xspeed-=7;
        }
        if (x>=batx+recw/4) {
          xspeed+=7;
        }
        frames = (2*maxv/GRAV)-2.5;
        xpredict = xspeed*frames; //wow look at all those ifs
        xpredict=x+xpredict; //check if prediction is outside window
        reflect(xpredict);
      }
      else if (y>height) { //missed the ball
        display = false;
        speed = 0;
        xspeed = random(-15, 15); //randomly generate ball starting xspeed
        x = width/2;
        y= 0;
        fails++;
        if (score > record) {
          record = score;
          
        }
        score = 0;
      }
      if (hit) {
        textAlign(BASELINE);
        textFont(d, 27);
        fill(100, 255, 0, alphaVal2);
        text("+"+mul, 150, 50);
        alphaVal2 = alphaVal2-2;
      }
      if (speed>maxv) {
        maxv=speed;
      }
      vel = sqrt(xspeed*xspeed+speed*speed);
      if (y<0) {
        speed=speed*-1;
        y=0;
      }
      if (x>width) {
        xspeed = xspeed*-1;
        x=width;
      }
      if (x<0) {
        xspeed = xspeed*-1;
        x=0;
      }
      rectMode(CENTER);
      noFill();
      rect(batx, height, recw, 10);
      y+=speed;
      x+=xspeed;
      speed+=GRAV;
      positionX[1]=x;
      positionY[1]=y;
      fill(100, 255, 0);
      if (keyPressed) {
        if (key =='d') {
          textFont(d, 12);
          if (debug) {
            text("debug mode: off", width/2, 20);
          }
          else {
            text("debug mode: on", width/2, 20);
          }
        }
      }
    }
  }
}
void keyReleased() {
  if (key == 'd') {
    debug=!debug;
    textFont(d, 18);
  }
  if(key == ' '){
    click = false;
  }
}
void reflect(float predict) {
  if (xpredict>width) {
    xpredict = 2*width-xpredict;
    predict = xpredict;
    if (predict<0) {
      reflect(predict);
    }
  }
  if (xpredict<0) {
    xpredict = xpredict*-1;
    predict=xpredict;
    if (predict>width) {
      reflect(predict);
    }
  }
}

void mouseMoved() {
  if (click) {
    moved = true;
  }
}
void HUD() {
  text("velocity guages", width-96, height/2-70);
  guage(speed, 0, "y", 4);
  guage(xspeed, 20, "x", 4);
  guage(vel, 40, "|v|", 4);
}
void guage(float var, float shift, String name, float mult) {
  strokeWeight(1);
  noFill();
  rectMode(CORNER);
  rect(width-20-shift, height-height/2-50, 16, height/2);
  textFont(d, 12);
  textAlign(CENTER);
  text(name, width-12-shift, height-height/2-55);
  strokeWeight(8);
  line(width-12-shift, height-64, width-12-shift, (-1*mult*abs(var))+height-75);
}
void bonus(float XVEL) {
  if (abs(XVEL)>0) {
    mul=1;
  }
  if (abs(XVEL)>8) {
    mul=2;
  }
  if (abs(XVEL)>16) {
    mul=4;
  }
  if (abs(XVEL)>24) {
    mul=8;
  }
  if (abs(XVEL)>32) {
    mul=16;
  }
  if (abs(XVEL)>40) {
    mul=32;
  }
  if (abs(XVEL)>48) {
    mul=64;
  }
}
void menus() {
  strokeWeight(1);
  fill(100, 255, 0);
  textFont(title, 50);
  rectMode(CENTER);
  textAlign(CENTER);
  noFill();
  rect(width/2, height/2, 200, height-50);
  text("Menu", width/2, height/4);
  textFont(d, 15);
  textbox("START", 1);
  textbox("Highscores", 2);
  textbox("options", 3);
  boxClick(width/2-90, width/2+90, height/4+15, height/4+45);
  }
  void textbox(String string, int place) {
    text(string, width/2, height/4+30*place);
    rect(width/2, height/4+30*place, 180, 30);
  }
void boxClick(float xlower, float xupper, float ylower, float yupper) {
  if ((mouseX>xlower)&&(mouseX<xupper)&&(mouseY>ylower)&&(mouseY<yupper)&&(mousePressed==true)) {
    click=true;
  }
}
void keyPressed(){
  if(key == ' '){
    click = false;
  }
}
  

