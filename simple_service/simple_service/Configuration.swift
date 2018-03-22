//
//  Configuration.swift
//  simple_service
//
//  Created by SK Telecom on 2018. 1. 2..
//  Copyright © 2018년 SK Telecom. All rights reserved.
//

import Foundation
import simple

let SERVER_MAIN_URL = "http://[TBD]"
let LOGIN_URL = "/api/v1/login"
let ATTRIBUTE_CHECK_URL = "/api/v1/dev/devicesdk/IOS/attribute";

//sample
//let HOST = Host(serviceName: "devicesdk", deviceName: "IOS", deviceToken: "ae63a9402b5d11e8b50f", host:"[TBD]", port: "8883", clientId: "ae63a9402b5d11e8b50f", userName: "", password: "", usingSSL: true, cleanSession: true)

//let CSV_HOST = Host(serviceName: "smartweather", deviceName: "ioscsv", deviceToken: "851ad800db1311e7b5bb", host:"api.sktiot.com", port: "8883", clientId: "851ad800db1311e7b5bb", userName: "851ad800db1311e7b5bb", password: nil, usingSSL: false, cleanSession: true)

let HOST = Host(serviceName: "", deviceName: "", deviceToken: "", host:"[TBD]", port: "8883", clientId: "", userName: "", password: "", usingSSL: true, cleanSession: true)

let CSV_HOST = Host(serviceName: "", deviceName: "", deviceToken: "", host:"[TBD]", port: "8883", clientId: "", userName: "", password: nil, usingSSL: true, cleanSession: true)


let ledColorArry = ["Off", "Red", "Green", "Blue", "Magenta", "Cyan", "Yellow", "White"]
let soundArry = ["Off", "Ringtone", "Notofication", "Alarm"]

public enum SensorType: Int {
    case SENSOR_BATTERY = 1
    case SENSOR_TEMPERATURE
    case SENSOR_HUMIDITY
    case SENSOR_NOISE
    case SENSOR_GPS
    case SENSOR_AIR_PRESSURE
    case SENSOR_LIGHT
    case SENSOR_BUZZER
    case SENSOR_LED
    case SENSOR_PROXIMITY
    case SENSOR_CAMERA
    case SENSOR_ACCELEROMETER
    case SENSOR_ORIENTATION
    case SENSOR_GRAVITY
    case SENSOR_GYROSCOPE
    case SENSOR_MAGNETIC
    case SENSOR_STEP_DETECTOR
    case SENSOR_STOP_COUNT
}

public enum MessageType: UInt8 {
    case TYPE_NONE = 1
    case TYPE_JSONSTRING
    case TYPE_CSV
    case TYPE_OFFSET
}

struct AttributeSensor {
    let sensorName: String
    let refreshToken: String
}

struct AttributeSensorData {
}
