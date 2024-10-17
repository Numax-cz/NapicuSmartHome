//
//  NapicuHomeBluetooth.swift
//  NapicuHome
//
//  Created by Marcel Mikoláš on 15.10.2024.
//

import CoreBluetooth

struct DiscoveredPeripheral {
    var peripheral: CBPeripheral
    var lastUpdate: Date
}

struct PeripheralDisplayItem {
    let name: String
    let uuid: UUID
}

class BluetoothManager: NSObject, ObservableObject {
    private var centralManager: CBCentralManager?
    private var foundPeripherals: [DiscoveredPeripheral] = []

    var targetUUID = CBUUID(string: "cea986c2-4405-11ee-be56-0242ac120002")
    
    @Published var peripheralsNames: [PeripheralDisplayItem] = [
        PeripheralDisplayItem(name: "Device #1", uuid: UUID()),
        PeripheralDisplayItem(name: "Device #2", uuid: UUID()),
        PeripheralDisplayItem(name: "Device #3", uuid: UUID()),
    ]
    @Published var scanning: Bool = false

    
    private var timer: Timer?
    
 
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    func startScan() {
        self.scanning = true
        if(!self.scanning && centralManager?.state == .poweredOn) {
            self.centralManager?.scanForPeripherals(withServices: nil)
         

            self.timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
                self?.updateScan()
            }
        }
    }
    
    func stopScan() {
        self.scanning = false
        self.centralManager?.stopScan()
        self.timer?.invalidate()
        self.timer = nil
    }
    
    
    func updateScan() {
        if(!foundPeripherals.isEmpty) {
            print("Bluetooth scan update")

            let currentDate = Date()

            foundPeripherals.removeAll { peripheral in
                let isExpired = currentDate.timeIntervalSince(peripheral.lastUpdate) > 3.0
                if isExpired {
                    peripheralsNames.removeAll { $0.name == peripheral.peripheral.name }
                    print("Removed \(peripheral.peripheral.name ?? "Unknown")")
                }
                return isExpired
            }
            
            self.centralManager?.stopScan()
            self.centralManager?.scanForPeripherals(withServices: nil)
        }
    }

}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {

    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    {
        if let index = foundPeripherals.firstIndex(where: { $0.peripheral == peripheral }) {
            foundPeripherals[index].lastUpdate = Date()
            return
        }

        if let serviceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
            if serviceUUIDs.contains(targetUUID) {
                if let name = peripheral.name {
                    foundPeripherals.append(DiscoveredPeripheral(peripheral: peripheral, lastUpdate: Date()))
                    
                    peripheralsNames.append(PeripheralDisplayItem(name: name, uuid: peripheral.identifier))
                }
            }
        }
    }
    
}
