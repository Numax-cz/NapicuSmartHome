//
//  DeviceManager.swift
//  NapicuHome
//
//  Created by Marcel Mikoláš on 31.10.2024.
//
import CoreBluetooth

class DeviceManager {
    var peripheral: CBPeripheral
    var isConnectedToWiFi: Bool = false
    
    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
    }
}
