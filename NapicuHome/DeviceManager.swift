//
//  DeviceManager.swift
//  NapicuHome
//
//  Created by Marcel Mikoláš on 31.10.2024.
//
import CoreBluetooth

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
     * Device peripherals
     */
    var peripheral: CBPeripheral
    
    @Published public var wifiStatus: WiFiState = .noCredentials
    
    /**
     * Available networks nearby
     */
    @Published public var nearbyNetworks: [String] = []
    
    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
    }
}
