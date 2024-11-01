#include <NapicuSmartHome/include/NapicuSmartHome.h>
#include <led.h>



// fe8c0e2c-daab-4eb7-a0d1-057044d931c0
// d193a3d7-a2f1-4961-8bd6-b7ba1df14701
// 210a69c9-eb1f-4f2a-b567-42bb92ba37cd
// 2cc4c853-b10f-4008-ac26-4bb4a0325181
// 946fe83f-053b-47d0-aa72-404bc5b0a47e
// 1372c0a1-78c2-42ea-8c5b-8fe200352bab
// c8dff686-02ca-4af5-acbf-417145645e33
// 3a1755e3-c43c-4e41-ac39-f511da1bb091
// 3db51db3-d57e-4cb0-8466-4d6efc2125b0


#define DEFAULT_BLE_NAME "NapicuSmartHome"
#define SERVICE_UUID "73f4a352-06ff-4c15-aaf8-4a498e882d50" 

#define CHARACTERISTIC_WIFI_STATE_UUID "803b6053-c7cf-4594-aa77-3ca2ff8d4a5e"


void setup() {
    Serial.begin(115200);

    //Bluetooth
    NapicuHome::begin_ble(DEFAULT_BLE_NAME, SERVICE_UUID, CHARACTERISTIC_WIFI_STATE_UUID);

    //Homekit 
    homeSpan.setLogLevel(-1);
    NapicuHome::begin_home("11122333", Category::Lighting, "NapicuSvetlo");



    // // Skenování Wi-Fi sítí
    // int numOfNetworks = WiFi.scanNetworks();

    // if (numOfNetworks == 0) {
    //     Serial.println("Nebyly nalezeny žádné Wi-Fi sítě.");
    // } else {
    //     Serial.println("Nalezené Wi-Fi sítě:");
    //     for (int i = 0; i < numOfNetworks; ++i) {
    //     Serial.print(i + 1);
    //     Serial.print(": ");
    //     Serial.print(WiFi.SSID(i));
    //     Serial.print(" (RSSI: ");
    //     Serial.print(WiFi.RSSI(i));
    //     Serial.println(" dBm)");
    //     delay(10);
    //     }
    // }

    new SpanAccessory();
    new Service::AccessoryInformation();
    new Characteristic::Identify();
    new DEV_LED(2);

}

void loop() {
    //homeSpan.poll();



    Serial.println("Scanning...");

  // Zahájení skenování
  int networkCount = WiFi.scanNetworks();
  Serial.println("Scan completed.");

  if (networkCount == 0) {
    Serial.println("No networks found.");
  } else {
    Serial.println("Networks found:");
    for (int i = 0; i < networkCount; i++) {
      // Výpis SSID a síly signálu (RSSI)
      Serial.print(i + 1);
      Serial.print(": ");
      Serial.print(WiFi.SSID(i));
      Serial.print(" (");
      Serial.print(WiFi.RSSI(i));
      Serial.println(" dBm)");
    }
  }

  // Vyprazdnění seznamu sítí, aby se aktualizoval v dalším skenování
  WiFi.scanDelete();
  
  // Zpoždění před dalším skenováním
  delay(10000);  // Skenování každých 10 sekund
}

