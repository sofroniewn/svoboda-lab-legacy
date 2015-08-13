/*
  Serial communication to sends signals from RTLinux to Matlab
   */

// set pin numbers:
const int screenOnPin = 0;
const int trialNumPin = A0;
const int mazeXCordPin = A1;
const int mazeYCordPin = A2;

long previousMillis = 0;
long interval = 5;           // interval at which to send data (milliseconds)

// the setup routine runs once when you press reset:
void setup() {
  pinMode(screenOnPin, INPUT);
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
}

// the loop routine runs over and over again forever:
void loop() {
  unsigned long currentMillis = millis();
  if (currentMillis < previousMillis) {
    previousMillis = 0;
  }
  if(currentMillis - previousMillis > interval) {
    // save the last time you blinked the LED 
    previousMillis = currentMillis;  
    
    // read the input on analog pin 0:
    int screenOn = digitalRead(screenOnPin);
    int trialNum = analogRead(trialNumPin);
    int mazeXCord = analogRead(mazeXCordPin);
    int mazeYCord = analogRead(mazeYCordPin);
    // print out the value you read:
    Serial.write(screenOn); // 0 or 1
    Serial.write(trialNum % 256); // send as low byte
    Serial.write(trialNum / 256); // send as high byte
    Serial.write(mazeXCord % 256); // send as low byte
    Serial.write(mazeXCord / 256); // send as high byte
    Serial.write(mazeYCord % 256); // send as low byte
    Serial.write(mazeYCord / 256); // send as high byte
  }
}


