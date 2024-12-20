
// 
// 2cc4c853-b10f-4008-ac26-4bb4a0325181
// 946fe83f-053b-47d0-aa72-404bc5b0a47e
// 1372c0a1-78c2-42ea-8c5b-8fe200352bab
// c8dff686-02ca-4af5-acbf-417145645e33
// 3a1755e3-c43c-4e41-ac39-f511da1bb091
// 3db51db3-d57e-4cb0-8466-4d6efc2125b0


#define SERVICE_UUID "73f4a352-06ff-4c15-aaf8-4a498e882d50" 
/**
 * Specifies the UUID used to retrieve the Wi-Fi status
 * from the connected device.
 */
#define CHARACTERISTIC_WIFI_STATE_UUID "803b6053-c7cf-4594-aa77-3ca2ff8d4a5e"
/**
 * Specifies the UUID used to retrieve the list of available
 * Wi-Fi networks from the connected device.
 */
#define CHARACTERISTIC_WIFI_LIST_UUID "fe8c0e2c-daab-4eb7-a0d1-057044d931c0"
/**
 * Specifies the UUID used to initiate a write operation
 * for connecting the device to a specified Wi-Fi network.
 * This characteristic allows the client to send the SSID 
 * and password to the connected device to establish a Wi-Fi connection.
 */
#define CHARACTERISTIC_WIFI_CONNECT_UUID "d193a3d7-a2f1-4961-8bd6-b7ba1df14701"


//EPROM definition for storing the MAC address of the paired device 
#define MAC_EEPROM_SIZE 6 //MAC address length in bytes
#define MAC_ADDRESS_EEPROM_ADDR 0 //Address in EEPROM memory where the MAC address will be stored