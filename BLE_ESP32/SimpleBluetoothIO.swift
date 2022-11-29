//
//  SimpleBluetoothIO.swift
//  BLE_ESP32
//
//  Created by Gabriel on 27/11/22.
//

import CoreBluetooth

// This protocol is a blueprint to a function that receives data from the peripheral
protocol SimpleBluetoothIODelegate: AnyObject {
    func simpleBluetoothIO(simpleBluetoothIO: SimpleBluetoothIO, didReceiveValue value: Int8)
}

class SimpleBluetoothIO: NSObject {
    let serviceUUID: String
    let serviceName: String
    weak var delegate: SimpleBluetoothIODelegate?
    
    var centralManager: CBCentralManager!   // Creates a Central Manager
    var connectedPeripheral: CBPeripheral?  //
    var targetService: CBService?
    var writableCharacteristic: CBCharacteristic?
    var isConnected: Bool? = false
    
    // SimpleBluetoothIO Contructor Class
    init(serviceUUID: String, delegate: SimpleBluetoothIODelegate?, serviceName: String) {
        self.serviceUUID = serviceUUID
        self.delegate = delegate
        self.serviceName = serviceName
        isConnected = false
        
        super.init()
        // Creates a Central Manager
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // This method writes data into the paired bluetooth device
    func writeValue(value: String) {
        // Check if its connected and if the peripheral is writtable, if not the, returns
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        
        // Writes the data into the BLE peripheral
        let data = Data.dataWithValue(value: value)
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
    
}

extension SimpleBluetoothIO: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // Checks if bletooth is on and then scans for peripherals
        if central.state == .poweredOn {
//             centralManager.scanForPeripherals(withServices: [CBUUID(string: serviceUUID)], options: nil)
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
        if let name = peripheral.name {
            print("Connected! With \(name)")
        }
        isConnected = true
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        isConnected = false
    }
    
    // Discovers BLE peripherals and connects to the one that its name is equals to the one passed to the contructor before
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        connectedPeripheral = peripheral
        if let name = peripheral.name {
            print("Discovered \(name)")
            if peripheral.name == serviceName {
                if let connectedPeripheral = connectedPeripheral {
                    connectedPeripheral.delegate = self
                    centralManager.connect(connectedPeripheral, options: nil)
                }
            }
            centralManager.stopScan()
        }
        
    }
}

extension SimpleBluetoothIO: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }
        
        targetService = services.first
        if let service = services.first {
            targetService = service
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        
        for characteristic in characteristics {
            if characteristic.properties.contains(.write) || characteristic.properties.contains(.writeWithoutResponse) {
                writableCharacteristic = characteristic
            }
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value, let delegate = delegate else {
            return
        }
        
        delegate.simpleBluetoothIO(simpleBluetoothIO: self, didReceiveValue: data.int8Value())
    }
}
