import themidibus.*;
import processing.sound.*;


int[] myVal = new int[11];
int frames;
int length = 60;
float angle = radians(length);
float smoothingFactor = 0.5;
float sum = 0;

SoundFile sample;
Amplitude rms;
MidiBus myBus;

void setup(){
  //size(1000, 1000);
  fullScreen();
  
  sample = new SoundFile(this, "Footfall.wav");
  sample.loop();
  
  rms = new Amplitude(this);
  rms.input(sample);
  
  //MidiBus.list();
  myBus = new MidiBus(this, "QuNexus", -1);


} 

void controllerChange(int channel, int number, int value){
  if(channel == 0){
    if(number == 1){
      myVal[1] = value;
    }
    if(number == 2){
      myVal[2] = value;
    }
    if(number == 3){
      myVal[3] = value;
    }
  }
  println();
  println("Controller Change:");
  println("--------");
  println("Channel: "+channel);
  println("Number: "+number);
  println("Value: "+value);
}

void draw(){
  background(0);
  
  frames ++;
  frames = frames%10;
  sum += (rms.analyze() - sum) * smoothingFactor; 
  float rmsScaled = sum * (height/(frames + 5)) * 5;
  
  for (int i = 1; i <= 50; i ++){
    resetMatrix();
    translate(width/2, height/2);
    int n = i;

    do{  
      n = collatz(n);
      if (n %2 == 0){
        rotate(-myVal[1]);
      } else {
        rotate(myVal[1]);
      }
      
      stroke(random(0, 255));
      curve(0, 0, rmsScaled, - length, rmsScaled * 2, - length * (rmsScaled/PI), rmsScaled, - length * (rmsScaled/(PI*2)));
      strokeWeight(5);
      //line(0, 0, 0, length);
      //fill(frames * 3.233, frames * 1.783, frames * 1.6167);
      translate(0, - length);
      
    }while (n != 1);
  }
}

int collatz(int n){
  if (n%2 == 0){
    return n/2;
  }
  else{
    return (n*3+1)/2;
  }
}
