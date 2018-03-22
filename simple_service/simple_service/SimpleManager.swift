//
//  SimpleUtil.swift
//  simple_service
//
//  Created by SK Telecom on 2018. 1. 2..
//  Copyright © 2018년 SK Telecom. All rights reserved.
//

import Foundation
import simple

protocol SimpleManagerDelegate{
    func mqttDidReceiveMessage(result:NSDictionary)
    func mqttallSubscribed()
}


class SimpleManager : MQTTDelegate{
    
    var mqttClient : MQTTClient
    var binder: Simple!
    var subscribeTopics: [SubscribeTopic] = []
    var publishTopic: String = ""
    var cmdId:NSInteger = 1
    //var repResponse :RPCResponse
    
    var delegate: SimpleManagerDelegate?
    
    init(messageType:MessageType) {
        
        self.mqttClient = MQTTClient(host: HOST)
        self.binder = Simple(mqttClient: mqttClient)
    
        self.subscribeTopics = [SubscribeTopic("v1/usr/\(HOST.userName ?? "")/down")]
    }
    
    func mqttConnect() {
        
        mqttClient.delegate = self as MQTTDelegate
        mqttClient.connect()
        
    }
    
    func mqtt(_ mqtt: MQTTClient, didConnect host: String, port: Int) {
        print("didConnect")
    }
    
    func mqtt(_ mqtt: MQTTClient, didConnectAck ack: MQTTConnAck) {
        print("didConnectAck")
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
            delegate?.mqttallSubscribed()
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
            let dic = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            print("dic : \(dic)")
            delegate?.mqttDidReceiveMessage(result: dic)
        }
    }
    
    func sendAttribute(attributeelement:NSMutableDictionary) {
        var messageId: UInt16 = 0

        messageId =  binder.tpSimpleAttribute(attributeelement)
        print("publish message id : \(messageId)")
    }
    
    func sendTelemetryelement(telemetryelement:NSMutableDictionary) {
        var messageId: UInt16 = 0
        messageId = binder.tpSimpleTelemetry(telemetryelement)
        print("publish message id : \(messageId)")
    }
    
    
    func subscribe(subscribe:NSMutableDictionary){
        var messageId: UInt16 = 0
        messageId =  binder.tpSimpleSubscribe(subscribe)
        print("publish message id : \(messageId)")
    }
    
    func SubscribeTopicSet(subscribeTopic:NSString){
        self.subscribeTopics = [SubscribeTopic(subscribeTopic as String)]
    }
    
    func takePhoto(controlParams:NSMutableArray, cmdId:NSInteger){
        var messageId: UInt16 = 0
        messageId = binder.tpSimpleJsonRpcReq(controlParams: controlParams, cmdId: cmdId, isTwoWay: true)
        print("publish message id : \(messageId)")
    }
    
    func setActivate(controlParams:NSMutableArray, cmdId:NSInteger){
        var messageId: UInt16 = 0
        messageId = binder.tpSimpleJsonRpcReq(controlParams: controlParams, cmdId: cmdId, isTwoWay: false)
        print("publish message id : \(messageId)")
    }
    
    func setAttribute(controlParams:NSMutableDictionary, cmdId:NSInteger){
        var messageId: UInt16 = 0
        messageId = binder.tpSimpleSetAttribute(controlParams: controlParams, cmdId: cmdId)
        print("publish message id : \(messageId)")
    }
    
    func controlResult(resultParams:NSMutableDictionary, cmd:NSString, jsonrpc:NSString, id:CLong, isSuccess: Bool){
        var messageId: UInt16 = 0
        /*
        self.repResponse = RPCResponse(cmd: cmd as String, cmdId: self.getCmdId(), jsonrpc: jsonrpc as String, id: id, result: isSuccess ? "success":"fail",  success: isSuccess, resultDic: resultParams)
        messageId = binder.tpSimpleResult(self.repResponse)
        print("publish message id : \(messageId)")
 */
    }

    func getCmdId() -> NSInteger {
        if(cmdId > NSInteger.max) {
            cmdId = 2;
        } else {
            cmdId += 1;
        }
        return cmdId;
    }
}
