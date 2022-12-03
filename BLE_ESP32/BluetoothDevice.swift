//
//  BluetoothDevice.swift
//  BLE_ESP32
//
//  Created by Gabriel on 03/12/22.
//  Copyright © 2022 pierdr. All rights reserved.
//

import Foundation

var dataGlobal: String?
var bluetoothDev: SimpleBluetoothIO! // Creates a BLE interface

class BluetoothDevice {
    init(deviceName: String!){
        bluetoothDev = SimpleBluetoothIO(
            serviceUUID: "4fafc201-1fb5-459e-8fcc-c5c9c331914b",
            delegate: self,
            serviceName: deviceName
        )
    }
}
extension BluetoothDevice: SimpleBluetoothIODelegate {
    func simpleBluetoothIO(simpleBluetoothIO: SimpleBluetoothIO, didReceiveValue value: String) {
        dataGlobal = value
    }
}
