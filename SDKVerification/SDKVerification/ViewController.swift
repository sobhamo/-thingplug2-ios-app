//
//  ViewController.swift
//  HelloThingPlug
//
//  Created by SK Telecom on 2017. 6. 27..
//  Copyright © 2017년 SK Telecom. All rights reserved.
//

import UIKit
import simple


public enum MessageType: UInt8 {
    case TYPE_NONE = 1
    case TYPE_JSONSTRING
    case TYPE_CSV
    case TYPE_OFFSET
}

class ViewController: UIViewController, MQTTDelegate, XMLParserDelegate {
    var isCsv:Bool = false
    
    var binder: Simple!
    
    var subscribeTopics: [SubscribeTopic] = []
    var publishTopic: String = ""
    
    @IBOutlet weak var resultTextView: UITextView!
    
    var printData: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mqttClient: MQTTClient
        
        if isCsv{
            mqttClient = MQTTClient(host: CSV_HOST)
            binder = Simple(mqttClient: mqttClient)
            subscribeTopics = [SubscribeTopic("v1/dev/\(CSV_HOST.serviceName)/\(CSV_HOST.deviceName)/down")]
        } else {
            mqttClient = MQTTClient(host: HOST)
            binder = Simple(mqttClient: mqttClient)
            subscribeTopics = [SubscribeTopic("v1/dev/\(HOST.serviceName)/\(HOST.deviceName)/down")]
        }

        mqttClient.delegate = self
        mqttClient.connect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayText(_ message: String) {
        resultTextView.insertText("\(message)\r\n")
    }
    
    func mqtt(_ mqtt: MQTTClient, didConnect host: String, port: Int) {
        print("didConnect")
    }
    
    func mqtt(_ mqtt: MQTTClient, didConnectAck ack: MQTTConnAck) {
        print("didConnectAck")
        displayText("connected!")
        // subscribe
        for (_, element) in subscribeTopics.enumerated() {
            mqtt.subscribeTopic(topic: element)
        }
    }
    
    func mqtt(_ mqtt: MQTTClient, didPublishMessage message: Message, id: UInt16) {
        print("didPublishMessage")
    }
    
    func mqtt(_ mqtt: MQTTClient, didPublishAck id: UInt16) {
        print("didPublishAck")
    }
    
    func mqtt(_ mqtt: MQTTClient, didSubscribeTopic topic: String) {
        print("didSubscribeTopic : \(topic):")
        var allSubscribed = true
        for (_, element) in subscribeTopics.enumerated() {
            if element.topicText == topic {
                element.isSubscribed = true
            }
        }
        
        for (_, element) in subscribeTopics.enumerated() {
            if element.isSubscribed == false {
                allSubscribed = false
            }
        }
        
        if allSubscribed {
            print("allSubscribed")
            displayText("subscribed!")
            self.sendAttribute()
            self.sendTelemetryelement()
        }
    }
    
    func mqtt(_ mqtt: MQTTClient, didUnsubscribeTopic topic: String) {
        print("didUnsubscribeTopic : \(topic):")
    }
    
    func mqttDidPing(_ mqtt: MQTTClient) {
        print("mqttDidPing")
    }
    
    func mqttDidReceivePong(_ mqtt: MQTTClient) {
        print("mqttDidReceivePong")
    }
    
    func mqttDidDisconnect(_ mqtt: MQTTClient, withError err: Error?) {
        print("mqttDidDisconnect")
    }
    
    func mqtt(_ mqtt: MQTTClient, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        print("didReceive")
    }
    
    func mqtt(_ mqtt: MQTTClient, didReceiveMessage message: Message, id: UInt16 ) {
        print("didReceiveMessage")
        print("topic  :  \(message.topic)")
        print("subscribedMessage :  \(message.subscribedMessage)")
        
        
        if let data = message.subscribedMessage.data(using: String.Encoding.utf8) {
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
            print("json : \(json)")
        }
    }
    
    func sendAttribute() {
        var messageId: UInt16 = 0
        displayText("sendAttribute!")
        if isCsv{
            
            var Attributeelement:[String:AnyObject] = NSMutableDictionary() as! [String : AnyObject]
            var elmentArry = [Attributeelement]
            
            Attributeelement = ["batteryTemperature" : 1 as AnyObject]
            elmentArry.append(Attributeelement)
            
            Attributeelement = ["batteryGuage" : 1 as AnyObject]
            elmentArry.append(Attributeelement)
            
            Attributeelement = ["temperature" : 1 as AnyObject]
            elmentArry.append(Attributeelement)
            

            
            var csvString = ""
            //let valueArry = NSArray()
            
            for (Attributeelement) in elmentArry {
                for (_ , value) in Attributeelement {
                    csvString = csvString.appending(", \(value)")
                }
            }
            
            csvString = String(csvString.characters.dropFirst(2))
            
            print("csvString : \(csvString)")
            messageId = binder.tpSimpleRawAttribute(csvString as NSString, messageType: .TYPE_CSV)
            
            //messageId =  binder.tpSimpleAttribute(Attributeelement as! NSMutableDictionary)
            //print("publish message id : \(messageId)")
        } else {
            let paramDictionary:NSMutableDictionary = [:]
            paramDictionary.addEntries(from: ["Battery" : 1])
            paramDictionary.addEntries(from: ["Temperature" : 1])
            messageId =  binder.tpSimpleAttribute(paramDictionary)
            print("publish message id : \(messageId)")
        }
    }
    
    func sendTelemetryelement() {
        var messageId: UInt16 = 0
        displayText("sendTelemetry!")
        if isCsv {
            //for MessageType CSV
            var TelemetryelementCsv: [String: AnyObject] = NSMutableDictionary() as! [String : AnyObject]
            
            var TelemetryelementCsvArry = [TelemetryelementCsv]
            
            TelemetryelementCsv = ["ts" : currentTimeInMiliseconds() as AnyObject]
            TelemetryelementCsvArry.append(TelemetryelementCsv)

            TelemetryelementCsv = ["temp1" : 26 as AnyObject]
            TelemetryelementCsvArry.append(TelemetryelementCsv)
            
            TelemetryelementCsv = ["humi1" : 48 as AnyObject]
            TelemetryelementCsvArry.append(TelemetryelementCsv)
            
            TelemetryelementCsv = ["light1" : 267 as AnyObject]
            TelemetryelementCsvArry.append(TelemetryelementCsv)
            
            
            var csvString = ""
            //let valueArry = NSArray()
            
            for TelemetryelementCsv in TelemetryelementCsvArry{
                for (_ , value) in TelemetryelementCsv {
                    csvString = csvString.appending(", \(value)")
                }
            }
            csvString = String(csvString.characters.dropFirst(2))
            
            print("csvString : \(csvString)")
            messageId = binder.tpSimpleRawTelemetry(csvString as NSString, messageType: .TYPE_CSV)
            
            print("publish message id : \(messageId)")
        } else {
            //for MessageType NONE
            
            let paramDictionary:NSMutableDictionary = [:]
            paramDictionary.addEntries(from: ["batteryTemperature" : 35.60])
            paramDictionary.addEntries(from: ["batteryGuage" : 63.0])
            paramDictionary.addEntries(from: ["temperature" : 27.810])
            paramDictionary.addEntries(from: ["ts" : currentTimeInMiliseconds()])
            messageId = binder.tpSimpleTelemetry(paramDictionary)
            
            /*
            //for MessageType JSONSTRING
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: paramDictionary, options: .prettyPrinted),
                let jsonString = String(data: jsonData, encoding: String.Encoding.utf8){
                messageId = binder.tpSimpleRawTelemetry(jsonString as NSString, messageType: .TYPE_JSONSTRING)
            }
             */
        }
    }
    
    
    func currentTimeInMiliseconds() -> Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970)
    }
    
}
