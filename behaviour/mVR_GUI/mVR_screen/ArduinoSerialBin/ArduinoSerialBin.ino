/*
  Serial communication to sends signals from RTLinux to Matlab
   */

// set pin numbers:
const int screenOnPin = 0;
const int trialNumPin = A0;
const int mazeXCordPin = A1;
const int mazeYCordPin = A2;

byte b[4];

// the setup routine runs once when you press reset:
void setup() {
  pinMode(screenOnPin, INPUT);
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
}

// the loop routine runs over and over again forever:
void loop() {
  // read the input on analog pin 0:
  int screenOn = digitalRead(screenOnPin);
  int trialNum = analogRead(trialNumPin);
  int mazeXCord = analogRead(mazeXCordPin);
  int mazeYCord = analogRead(mazeYCordPin);
  // print out the value you read:
  Serial.write(0); // 0 or 1
  Serial.write(99); // 0 to 1023 send as 4 bytes
  
  IntegerToBytes(754, b);
  for (int i=0; i<4; ++i)
  {
  Serial.write((int)b[i]); // send as byte
  }
  
  Serial.write(511); // 0 to 1023 send as 4 bytes
  //Serial.write(screenOn); // 0 or 1
  //Serial.write(trialNum); // 0 to 1023
  //Serial.write(mazeXCord); // 0 to 1023
  //Serial.write(mazeYCord); // 0 to 1023
  delay(1);        // delay in between reads for stability
}

void IntegerToBytes(int val, byte b[4])
{
  b[3] = (byte )((val >> 24) & 0xff);
  b[2] = (byte )((val >> 16) & 0xff);
  b[1] = (byte )((val >> 8) & 0xff);
  b[0] = (byte )((val) & 0xff);
}
