#pragma once

#include <HomeSpan.h>
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <NapicuSmartHome/include/config.h>


class NapicuHome {
public:
    /**
     * @brief ESP32 WiFi connection status types
     * 
     */
    enum class WiFiState {
        WiFiNoCredentials = 0,    /* ESP32 has no WiFi connection data */
        WiFiConnected =     1,    /* ESP32 is connected to WiFi */
        WiFiDisconected =   2,    /* ESP32 is disconnected from WiFi */
        WiFiAuthFailed =    3,    /* Wi-Fi authentication failed (incorrect password or other issues) */
        WiFiAuthPending =   4     /* Wi-Fi authentication is pending or in progress */
    };

    /**
     * @brief Starts service for apple homekit
     * 
     * @param pairingCode Pairing code for apple home kit
     * @param catID Accessory category ID 
     * @param displayName Name that will be displayed
     * @param hostNameBase Name of host
     * @param modelName Name of model
     */
    static void begin_home(const char *pairingCode, Category catID = Category::Lighting, const char *displayName = "HomeSpan Server", const char *hostNameBase = "HomeSpan", const char *modelName = "HomeSpan-ESP32");
    /**
     * @brief Starts Bluetooth low energy service
     * 
     * @param deviceName Name that will be displayed
     */
    static void begin_ble(const char *deviceName);
    /**
     * @brief Get the wifi status
     * 
     * @return WiFiState 
     */
    static NapicuHome::WiFiState get_wifi_status();
    /**
     * @brief Disconnects the device from the current Wi-Fi network.
     */
    static void disconnect_from_wifi();
    /**
     * @brief Connects the device to a Wi-Fi network
     * 
     * @param ssid The name of the Wi-Fi network to connect to.
     * @param pwd The password for the Wi-Fi network.
     */
    static void connect_to_wifi(const char* ssid, const char *pwd); //TODO return

private:
    static BLEServer *ble_server;
    static BLEService *ble_service_wifi;
    static BLEAdvertising *ble_advertising;

    static BLECharacteristic *wifi_state_characteristic;
    static BLECharacteristic *wifi_list_characteristic;
    static BLECharacteristic *wifi_connect_characteristic;

    static const char *pairingCode;

    class ServerCallBack : public BLEServerCallbacks {
    public:
        void onConnect(BLEServer* pServer, esp_ble_gatts_cb_param_t *param);
        void onDisconnect(BLEServer* pServer);
    };
    /**
     * @brief Characteristics for network status query 
     * 
     */
    class WiFiStateCharacteristicCallback : public BLECharacteristicCallbacks {
    public:
        void onRead(BLECharacteristic *pCharacteristic); 
    };
    /**
     * @brief Characteristics for network status query 
     * 
     */
    class WiFiListCharacteristicCallback : public BLECharacteristicCallbacks {
    public:
        void onRead(BLECharacteristic *pCharacteristic); 
    };
    /**
     * @brief Characteristics for connect to network
     * 
     */
    class WiFiConnectCharacteristicCallback : public BLECharacteristicCallbacks {
    public:
        void onWrite(BLECharacteristic *pCharacteristic); 
    };
    /**
     * @brief Characteristics for disconnect from network
     * 
     */
    class WiFiDisconnectCharacteristicCallback : public BLECharacteristicCallbacks {
    public:
        void onRead(BLECharacteristic *pCharacteristic); 
    };

    /**
     * @brief Starts the HomeSpan package and initializes the HomeKit setup.
     * 
     * This function is responsible for starting the HomeSpan package, which
     * initializes the HomeKit framework and prepares the device to be controlled
     * via Apple’s Home app or other HomeKit-compatible apps.
     */
    static void start_home_span();
    /**
     * @brief Returns whether the data from the wifi network is saved
     * But not if the device is connected!
     * 
     * @return true 
     * @return false 
     */
    static bool wifi_credentials_exists();
    /**
     * @brief Handles Wi-Fi events triggered by the ESP32 Wi-Fi driver
     * 
     * @param event Wi-Fi event
     */
    static void on_wifi_event(WiFiEvent_t event, WiFiEventInfo_t info);
    /**
     * @brief Handles Bluetooth Low Energy (BLE) GAP events.
     * 
     * @param event The BLE GAP event type.
     * @param param The parameters associated with the BLE GAP event.
     */
    static void ble_gap_event_handler(esp_gap_ble_cb_event_t  event, esp_ble_gap_cb_param_t* param);
    /**
     * @brief Sends a notification to indicate a change in the Wi-Fi status.
     * 
     * This function is responsible for notifying connected BLE devices
     * about any updates or changes in the Wi-Fi status, such as
     * connection, disconnection
     */
    static void notify_wifi_status_change();
    /**
     * @brief Sends a notification to indicate a failed Wi-Fi authentication attempt.
     * 
     * This function is responsible for notifying the connected BLE device
     * about a failed Wi-Fi authentication. The notification will update the
     * authentication status, indicating that the Wi-Fi authentication has
     * failed and provide the corresponding status value.
     */
    static void notify_wifi_auth_failed() {
        if(NapicuHome::wifi_state_characteristic) {
            int auth_value = static_cast<int>(NapicuHome::WiFiState::WiFiAuthFailed);
            NapicuHome::wifi_state_characteristic->setValue(String(auth_value).c_str());
            NapicuHome::wifi_state_characteristic->notify();
        }
    }
};