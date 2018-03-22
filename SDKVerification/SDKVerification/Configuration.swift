//
//  Configuration.swift
//  SDKVerification
//
//  Created by SK Telecom on 2017. 7. 1..
//  Copyright © 2017년 SK Telecom. All rights reserved.
//

import Foundation
import simple



let HOST = Host(serviceName: "devicesdk", deviceName: "IOS", deviceToken: "ae63a9402b5d11e8b50f", host:"api.sktiot.com", port: "8883", clientId: "ae63a9402b5d11e8b50f", userName: "ae63a9402b5d11e8b50f", password: nil, usingSSL: true, cleanSession: true)

//let HOST = Host(serviceName: "", deviceName: "", deviceToken: "", host:"iot.eclipse.org", port: "8883", clientId: "go-simple", userName: nil, password: nil, usingSSL: true, cleanSession: true)

let CSV_HOST = Host(serviceName: "smartweather", deviceName: "ioscsv", deviceToken: "851ad800db1311e7b5bb", host:"api.sktiot.com", port: "8883", clientId: "851ad800db1311e7b5bb", userName: "851ad800db1311e7b5bb", password: nil, usingSSL: true, cleanSession: true)
