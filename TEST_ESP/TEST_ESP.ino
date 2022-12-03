#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>

// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

#define LED_PIN 13
#define BTN_PIN 12

int deviceConnected = false;


class MyCallbacks: public BLECharacteristicCallbacks {
   void onConnect(BLEServer* pServer) {
      deviceConnected = true;
      Serial.println("device connected");
    };
 
    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
      Serial.println("device disconnected");
    }
    void onWrite(BLECharacteristic *pCharacteristic) {
      std::string value = pCharacteristic->getValue();
      if (value.length() > 0) {
          //Serial.println(value.c_str);
//        Serial.print("*********");
        Serial.println(value.c_str());
//        Serial.print("-");
//        Serial.print(atoi(value.c_str()));
//        Serial.print("-");
        if(atoi(value.c_str())==1)
        {
          digitalWrite(LED_PIN,HIGH);
          //Serial.print("LEDON");
        }
//        else
//        {
//          digitalWrite(LED_PIN,LOW);
//          Serial.print("LEDOFF");
//        }
//        
//        Serial.println("*********");
      }
    }
};

BLECharacteristic *pCharacteristic;
void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN,OUTPUT);
  digitalWrite(LED_PIN,LOW);

  BLEDevice::init("BLE_DEVICE");
  BLEServer *pServer = BLEDevice::createServer();

  BLEService *pService = pServer->createService(SERVICE_UUID);

  pCharacteristic= pService->createCharacteristic(
                                         CHARACTERISTIC_UUID,
                                         BLECharacteristic::PROPERTY_READ |
                                         BLECharacteristic::PROPERTY_WRITE |
                                         BLECharacteristic::PROPERTY_NOTIFY
                                       );

  pCharacteristic->setCallbacks(new MyCallbacks());

  pCharacteristic->setValue("Hello World");
  pService->start();

  BLEAdvertising *pAdvertising = pServer->getAdvertising();
  pAdvertising->start();

  pCharacteristic->setValue(String("manda").c_str());
   pCharacteristic->notify();
}
int prevVal = LOW;

int temp  = 0;
void loop() { 
//  int currentVal = digitalRead(BTN_PIN);
//  if(currentVal!=prevVal)
//  {
//    prevVal=currentVal;
//    if(currentVal==HIGH)
//    {
//      int value = 10;
//      pCharacteristic->setValue((uint8_t*)&value, 4);
//        pCharacteristic->notify();
//    }
//    else
//    {
//      pCharacteristic->setValue("teste off");
//        pCharacteristic->notify();
//    }
//  }
  temp++;
  pCharacteristic->setValue(String(temp).c_str());
   pCharacteristic->notify();
   delay(1000);
}
