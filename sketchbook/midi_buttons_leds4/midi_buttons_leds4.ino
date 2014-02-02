/* Buttons to USB MIDI Example

   You must select MIDI from the "Tools > USB Type" menu

   To view the raw MIDI data on Linux: aseqdump -p "Teensy MIDI"

   This example code is in the public domain.
*/

#include <Bounce.h>
#include <Adafruit_NeoPixel_teensy.h>
#include <Adafruit_GFX.h>
#include <Adafruit_PCD8544.h>



// the MIDI channel number to send messages
const int channel = 1;
const int numberOfRows = 2;
const int numberOfColumns = 2;

#define LED_STRIP_PIN 21
#define NUMBER_OF_PIXELS 8
Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUMBER_OF_PIXELS, LED_STRIP_PIN, NEO_GRB + NEO_KHZ800);

// pin 8 - Serial clock out (SCLK)
// pin 12 - Serial data out (DIN)
// pin 11 - Data/Command select (D/C)
// pin 9 - LCD chip select (CS)
// pin 10 - LCD reset (RST)
Adafruit_PCD8544 display = Adafruit_PCD8544(8, 12, 11, 9, 10);

const int ledPin = 13;

int rowPins[] = {0, 1}; // analog input of row
int columnPins[] = {16, 17}; // digital output of column activation feed

int buttonNote[] = {60, 64, 63, 67, 67, 71, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
int buttonState[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int buttonValue[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
unsigned long previousTime[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

void setup() {  
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, HIGH);   // set the LED on
  
  initializeColumnPins();
  initializeDisplay();
  
  strip.begin();
  strip.show(); // Initialize all pixels to 'off'
}

void loop() {

  int columnIndex;
  for (columnIndex=0; columnIndex<numberOfColumns; columnIndex++) {
    digitalWrite(columnPins[columnIndex], HIGH); // activate column

    int rowIndex;
    for (rowIndex=0; rowIndex<numberOfRows; rowIndex++) {
      int buttonIndex = rowIndex * numberOfColumns + columnIndex;
      
      int val = analogRead(rowPins[rowIndex]);
    
      if (buttonState[buttonIndex] == 0) {
        if (val > 40) {
          display.clearDisplay();
          display.setCursor(0,0);
          display.print("val1: ");
          display.print(val);
          display.print(" ");
          display.println(buttonIndex);
          display.display();
    
          previousTime[buttonIndex] = micros();
          buttonValue[buttonIndex] = val;
          buttonState[buttonIndex] = 1;
        }
      } else if (buttonState[buttonIndex] == 1) {
        if (val < 35) {
          buttonValue[buttonIndex] = 0;
          buttonState[buttonIndex] = 0;
        } else if (val > 300) {
          display.setCursor(0,10);
          display.print("val2: ");
          display.println(val);
          unsigned long currentTime = micros();
          unsigned long elapsedTime = elapsed(previousTime[buttonIndex], currentTime);
          unsigned long velocity = (val - buttonValue[buttonIndex]) * 1000 / elapsedTime;
          if (velocity > 127) {
            velocity = 127;
          }
          display.setCursor(0,20);
          display.print("velocity: ");
          display.println(velocity);
          display.display();
          noteOn(buttonIndex, velocity);
          buttonState[buttonIndex] = 2;
        }
      } else if (buttonState[buttonIndex] == 2) {
        if (val < 20) {
          noteOff(buttonIndex);
          buttonValue[buttonIndex] = 0;
          buttonState[buttonIndex] = 0;
        } else {
          display.setCursor(0,30);
          display.print("val4: ");
          display.fillRect(35, 30, 30, 10, WHITE);
          display.setCursor(7*5,30);
          display.println(val);
          display.display();
          unsigned long velocity = val/2;
          if (velocity > 127) {
            velocity = 127;
          }
          usbMIDI.sendAfterTouch(velocity, channel);
        }      
      }
    }      
    digitalWrite(columnPins[columnIndex], LOW); // deactivate column


  }
  
  // MIDI Controllers should discard incoming MIDI messages.
  // http://forum.pjrc.com/threads/24179-Teensy-3-Ableton-Analog-CC-causes-midi-crash
  while (usbMIDI.read()) {
    // ignore incoming messages
  }
}

void noteOn (int button) {
    digitalWrite(ledPin, HIGH);    // set the LED off
    usbMIDI.sendNoteOn(buttonNote[button], 99, channel);
    strip.setPixelColor(button, strip.Color(0, 0, 100));
    strip.show();
}

void noteOn (int button, int velocity) {
    digitalWrite(ledPin, HIGH);    // set the LED off
    usbMIDI.sendNoteOn(buttonNote[button], velocity, channel);
    strip.setPixelColor(button, strip.Color(100, 0, 0));
    strip.setPixelColor(4, strip.Color(0, 0, 0));
    strip.setPixelColor(5, strip.Color(0, 0, 0));
    strip.setPixelColor(6, strip.Color(0, 0, 0));
    strip.setPixelColor(7, strip.Color(0, 0, 0));
    if (velocity > 25) {
      strip.setPixelColor(4, strip.Color(0, 100, 0));
    }
    if (velocity > 50) {
      strip.setPixelColor(5, strip.Color(0, 100, 0));
    }
    if (velocity > 75) {
      strip.setPixelColor(6, strip.Color(0, 100, 0));
    }
    if (velocity > 100) {
      strip.setPixelColor(7, strip.Color(0, 100, 0));
    }
    strip.show();
}

void noteOff (int button) {
    digitalWrite(ledPin, LOW);    // set the LED off
    usbMIDI.sendNoteOff(buttonNote[button], 0, channel);
    strip.setPixelColor(button, strip.Color(0, 0, 0));
    strip.show();
}

unsigned long elapsed(unsigned long previousTime, unsigned long currentTime) {
  unsigned long elapsedTime = currentTime - previousTime;
  if (previousTime < currentTime) {
    elapsedTime = currentTime - previousTime;
  } else {
    Serial.println("rotated");
    elapsedTime = 429497295 - previousTime + currentTime;
  }
  return elapsedTime;
}

void initializeColumnPins() {
  int i;
  for (i=0; i<numberOfColumns; i++) {
    pinMode(columnPins[i], OUTPUT);
  } 
}

void initializeDisplay() {
  display.begin();
  display.setContrast(55);
  display.clearDisplay();   // clears the screen and buffer
  display.setTextSize(1);
  display.setTextColor(BLACK);
  display.setCursor(0,0);
  display.println("Hello, world!");
  display.display();
}

