//
//  File.swift
//  BLE_ESP32
//
//  Created by Gabriel on 30/11/22.
//  Copyright © 2022 pierdr. All rights reserved.
//

import Foundation

func getJsonData(JSON: String) -> JsonStingfier {
    let jsonData = JSON.data(using: .utf8)!
    let data: JsonStingfier = try! JSONDecoder().decode(JsonStingfier.self, from: jsonData)
    
    return data
}
struct JsonStingfier: Decodable {
    enum Device: String, Decodable {
        case position
    }
    enum Action: String, Decodable {
        case request, set_begin
    }
    enum TypeOfAction: String, Decodable {
        case throttle
    }

    let device: Device
    let action: Action
    let type: TypeOfAction
    let value: Double
}

extension Data {
    static func dataWithValue(value: String) -> Data {
        var variableValue = value
        return Data(buffer: UnsafeBufferPointer(start: &variableValue, count: 1))
    }
    
    func int8Value() -> Int8 {
        return Int8(bitPattern: self[0])
    }
}


/*
 Template for json file
 
    TEMPLATE REQUEST/RESPONSE
 Request
 {
    "device": "position",
    "action": "request",
    "type": "throttle",
 }
 Response
 {
    "device": "position",
    "action": "request",
    "type": "throttle",
    "value": "2.35",
 }
 
    TEMPLATE WRITER
 {
    "device": "position",
    "action": "set_begin",
    "type": "throttle",
    "value": "2.35"
 }

*/
