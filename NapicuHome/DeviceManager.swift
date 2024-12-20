//
//  DeviceManager.swift
//  NapicuHome
//
//  Created by Marcel Mikoláš on 31.10.2024.
//
import CoreBluetooth

struct WiFiInformations {
    let ssid: String
    let auth_mode: Int
}



class DeviceManager: ObservableObject {
    /**
     * ESP32 WiFi connection status types
     */
    enum WiFiState: Int {
          case noCredentials = 0 // ESP32 has no WiFi connection data
          case connected = 1     // ESP32 is connected to WiFi
          case disconnected = 2   // ESP32 is disconnected from WiFi
      }
    
    /**
     * ESP32 Wi-Fi authentication status types
     */
    enum WiFiAuth: Int {
        case authSuccess = 0   // Wi-Fi authentication was successful
        case authFailed = 1    // Wi-Fi authentication failed (incorrect password or other issues)
        case authPending = 2   // Wi-Fi authentication is pending or in progress
    }

    /**
     * Device peripherals
     */
    var peripheral: CBPeripheral
    
    @Published public var wifiStatus: WiFiState = .noCredentials
    
    /**
     * Available networks nearby
     */
    @Published public var nearbyNetworks: [WiFiInformations] = []
    
    @Published public var connectedWiFi: String?
    
    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
    }
    
    
    func readWiFiState() {
        if let services = self.peripheral.services {
            for service in services {
                if let characteristic = service.characteristics?.first(where: { $0.uuid == Config.BL_WIFI_STATE_CHARACTERISTIC_UUID }) {
                    self.peripheral.readValue(for: characteristic)
                    return
                }
            }
        }
        print("Characteristic about the status of the Wi-Fi network not found.")
    }

    func readWiFiList() {
        if let services = self.peripheral.services {
            for service in services {
                if let characteristic = service.characteristics?.first(where: { $0.uuid == Config.BL_WIFI_LIST_CHARACTERISTIC_UUID }) {
                    peripheral.readValue(for: characteristic)
                    return
                }
            }
        }
        print("Characteristic of the Wi-Fi network list not found.")
    }
    
    func connectToWiFi(ssid: String, pwd: String) {
        if let services = self.peripheral.services {
            for service in services {
                if let characteristic = service.characteristics?.first(where: { $0.uuid == Config.BL_WIFI_CONNECT_CHARACTERISTIC_UUID }) {
                    if let dataToSend = "\(ssid)|\(pwd)".data(using: .utf8) {
                           peripheral.writeValue(dataToSend, for: characteristic, type: .withResponse)
                    }
                    return
                }
            }
        }
        print("Characteristic of the Wi-Fi connection not found.")
    }
}
