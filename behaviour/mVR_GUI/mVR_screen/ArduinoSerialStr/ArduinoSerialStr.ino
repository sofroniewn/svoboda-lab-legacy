/*
  Serial communication to sends signals from RTLinux to Matlab
   */

// set pin numbers:
const int screenOnPin = 2;
const int trialNumPin = A0;
const int mazeXCordPin = A1;
const int mazeYCordPin = A2;

long previousMillis = 0;
long interval = 60;           // interval at which to send data (milliseconds)

// the setup routine runs once when you press reset:
void setup() {
  pinMode(screenOnPin, INPUT);
  // initialize serial communication at 19200 bits per second:
  Serial.begin(115200);
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
    Serial.print(screenOn); // 0 or 1
    Serial.print(","); //
    Serial.print(trialNum); // 0 to 1023
    Serial.print(","); //
    Serial.print(mazeXCord); // 0 to 1023
    Serial.print(","); //
    Serial.println(mazeYCord); // 0 to 1023
    }
}


