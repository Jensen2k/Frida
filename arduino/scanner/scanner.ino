#include <avrpins.h>
#include <max3421e.h>
#include <usbhost.h>
#include <usb_ch9.h>
#include <Usb.h>
#include <usbhub.h>
#include <avr/pgmspace.h>
#include <address.h>
#include <hidboot.h>

#include <printhex.h>
#include <message.h>
#include <hexdump.h>
#include <parsetools.h>

// For Ethernet Shield
#include <SPI.h>
#include <Ethernet.h>

// Tones
#define toneB4 494
#define toneB5 988

class FNetwork {
  public:
    FNetwork();
    ~FNetwork();
    void init();

    // Network methods
    void addRequest(String m, String p, String d, String o);
    void executeRequest();

    // Sound methods
    void playScanSound();
    void playErrorSound();

    // Temperature method
    void tempRequest();

    // Door methods
    void doorRequest(String doorReq);

    int lastTime;
    String request;  // Expires?
    byte mac[];
    EthernetClient client;

  
  private:
    int getContentLength(String data, String other);
    
    // Sound variables
    byte speakerPin;
    //int toneB4;
    //int toneB5;
};

class FScanner : public KeyboardReportParser {
  public:
    FScanner();
    ~FScanner();
    FNetwork *networking; 

  private:
    String barcode;
    boolean scanned;

  protected:
    virtual void OnKeyDown(uint8_t mod, uint8_t key);
    virtual void OnKeyPressed(uint8_t key);
    
};


FScanner::FScanner() {
  barcode = "";
  scanned = false;
}

FScanner::~FScanner() {
  // Nothing to destruct
}


void FScanner::OnKeyDown(uint8_t mod, uint8_t key)
{
  uint8_t c = OemToAscii(mod, key);

  if (c) {
    if (!scanned) {
      networking->playScanSound(); //DEBUG
      scanned = true;
    }
    if(c == 19) {
      scanned = false;
    }
  }

  if (c)
    OnKeyPressed(c);
}

void FScanner::OnKeyPressed(uint8_t key)
{

  if(key == 19) {
    networking->addRequest("POST", "/groceries/ean", barcode, "ean");
    networking->executeRequest();

    barcode = "";
    return;
  }
  
  barcode.concat((char)key);

};


FNetwork::FNetwork() {
  byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED }; // ethernet-controllerens mac
  lastTime = 1000;
  speakerPin = 3;

}

FNetwork::~FNetwork() {
  // Nothing to destruct
}

void FNetwork::playScanSound() {
  pinMode(speakerPin, OUTPUT);
  tone(speakerPin, toneB5);
  delay(175);
  noTone(speakerPin);
}


void FNetwork::playErrorSound() {
  pinMode(speakerPin, OUTPUT);
  
  tone(speakerPin, toneB4);
  delay(72);
  noTone(speakerPin);
  delay(20);
  tone(speakerPin, toneB4);
  delay(72);
  noTone(speakerPin);
  delay(20);
  tone(speakerPin, toneB4);
  delay(72);
  noTone(speakerPin);

}

void FNetwork::executeRequest() {

  String data = request;
    
  if (client.connect(IPAddress(176,58,103,76), 82)) {
    // send the HTTP PUT request:
    char charBufr[data.length()];
    data.toCharArray(charBufr, data.length());
    char *str;
    str = strtok(charBufr, ";");
    while (str != NULL){ // delimiter is the semicolon
      client.println(str);
      str = strtok(NULL, ";");
    }
  }
  else {
    playErrorSound();
  }

  data = "";
  client.stop();
}
  
// Setting request
void FNetwork::addRequest(String m, String p, String d, String o) {
  request = m+" "+ p +" HTTP/1.1;"
  "Host: www.fridafridge.com;"
  "User-Agent: frida+arduino;"
  "Connection: close;"
  "Content-Type: application/json;"
  "Content-Length: "+getContentLength(d, "{\""+o+"\": }\"\"")+";"
  ";\n"
  "{\""+o+"\": \""+d+"\"}"
  "; ";
}

int FNetwork::getContentLength(String data, String other) {
  String all = data+other;
  return all.length();
}

void FNetwork::init() {
  // give the ethernet module time to boot up:
  delay(1000);

  // start the Ethernet connection using a fixed IP address and DNS server:
  Ethernet.begin(mac, IPAddress(192,168,2,5), IPAddress(192,168,2,1), IPAddress(192,168,2,1));


}

USB  Usb;
HIDBoot<HID_PROTOCOL_KEYBOARD> HidKeyboard(&Usb);
uint32_t next_time;

FScanner scanner;
FNetwork networking;

// Temperature 
unsigned long lastTemp = 0;

// Door values
int doorState = 0;
boolean openState = false;
boolean closedState = true;
boolean openErrorState = false;
unsigned long lastDoor = 0;
unsigned long errorDoor = 0;


void setup()
{
  Serial.begin( 115200 );
  setupScanner();

  networking.init();
  delay(200);
}

void setupScanner() {

  if (Usb.Init() == -1) 
    delay( 200 );
    next_time = millis() + 5000;
    HidKeyboard.SetReportParser(0, (HIDReportParser*)&scanner);
    scanner.networking = &networking;
}

void loop()
{
  if(openState) {
    Usb.Task();
  }
  
  // Sending temperature reading
  if(millis() - lastTemp > (30000) ) {
    networking.tempRequest();
  }

  // Reads the photosensor every second
  if(millis() - lastDoor > 1000 ) {
      
      //Read current door state
     doorState = analogRead(A1);

    // When door opens, send one request
    if(doorState > 200 && !openState) {
      networking.doorRequest("1");
      openState = true;
      closedState = false;
    }

    // When door is open for too long
    if(millis() -  errorDoor > (600000) && !openErrorState) {
      networking.doorRequest("3");
      openErrorState = true;
    }

    if(millis() -  errorDoor > (600000) && openState) {
      networking.playErrorSound();
    }

    // When door closes, send one request
    if(doorState < 200 && !closedState ) {
      networking.doorRequest("0");
      closedState = true;
      openErrorState = false;

    }
    
    // setting closed door state
    if(doorState < 200) {
      openState = false;
      errorDoor = millis();
    }

    lastDoor = millis();

  }
}

// Method to send temperature
void FNetwork::tempRequest() {
  float value = analogRead(A0);
  float voltage = (value/1024.0)*5.0;
  float temp = (voltage-0.5)*100;
  
  char charBuf[15];
  dtostrf(temp, 1, 0, charBuf);
  String tempString = charBuf;
  //Serial.println(tempString);
  addRequest("POST", "/fridges/1/temp", tempString, "temp");
  executeRequest();

  lastTemp = millis();
}
// Method to send door state
void FNetwork::doorRequest(String doorReq) {
  //Serial.println("Door state: " + doorReq);
  addRequest("POST", "/fridges/1/door", doorReq, "door");
  executeRequest();
}