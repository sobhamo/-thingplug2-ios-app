 //
//  ViewController.swift
//  simple_service
//
 //  Created by SK Telecom on 2018. 1. 2..
 //  Copyright © 2018년 SK Telecom. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, SimpleManagerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var sensorUIData = SensorUIData()
    var simpleMenager : SimpleManager!
    var timer = Timer()

    var statuArry:NSArray!
    var decodedimage:UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if (HOST.userName?.isEmpty)!
        {
            showLogin()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func switchAtValueChanged(sender: UISwitch) {
        print("sender.tag : \(sender.tag)")
        print("sender.isOn : \(sender.isOn)")
        
        let paramArray:NSMutableArray = []
        let paramDictionary:NSMutableDictionary = [:]

        if(sender.isOn) {
            paramDictionary.addEntries(from: [self.sensorUIData.Sensors[sender.tag - 1].sensorValueName[0] as! NSString : 1])
        } else {
            paramDictionary.addEntries(from: [self.sensorUIData.Sensors[sender.tag - 1].sensorValueName[0] as! NSString : 0])
        }
        paramArray.add(paramDictionary)
        self.simpleMenager.setActivate(controlParams: paramArray, cmdId: self.simpleMenager.getCmdId())
        if(sender.isOn) {
            self.sensorUIData.Sensors[sender.tag - 1].sensorIsActivated = true
        } else {
            self.sensorUIData.Sensors[sender.tag - 1].sensorIsActivated = false
        }
        
    }
    
    @objc func onCellButtonClick(sender: UIButton) {
        print("sender.tag : \(sender.tag)")
        
        let sensorName:NSString = self.sensorUIData.Sensors[sender.tag - 1].sensorName
        
        switch sensorName {
        case "Led":
            showActionSheet(type: .SENSOR_LED)
            break
        case "Camera":
            showActionSheet(type: .SENSOR_CAMERA)
            break
        case "Buzzer":
            showActionSheet(type: .SENSOR_BUZZER)
            break
        default:
            break
        }
    }
    
    func showActionSheet(type :SensorType){
        
        let optionMenu = UIAlertController(title: nil, message: "Select one", preferredStyle: .actionSheet)
        
        if (type == .SENSOR_CAMERA){
            let backCameraAction = UIAlertAction(title: "Back Camera", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                let paramArray:NSMutableArray = []
                let paramDictionary:NSMutableDictionary = [:]
                paramDictionary.addEntries(from: ["camera" : 0])
                paramArray.add(paramDictionary)
                
                self.simpleMenager.takePhoto(controlParams: paramArray, cmdId: self.simpleMenager.getCmdId())
            })
            let frontCameraAction = UIAlertAction(title: "Front Camera", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                let paramArray:NSMutableArray = []
                let paramDictionary:NSMutableDictionary = [:]
                paramDictionary.addEntries(from: ["camera" : 1])
                paramArray.add(paramDictionary)
                self.simpleMenager.takePhoto(controlParams: paramArray, cmdId: self.simpleMenager.getCmdId())
            })

            optionMenu.addAction(backCameraAction)
            optionMenu.addAction(frontCameraAction)

        } else if (type == .SENSOR_BUZZER) {
            for var soundName in soundArry {
                optionMenu.addAction(UIAlertAction(title: soundName, style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    let index = optionMenu.actions.index(of: alert)
                    if index != nil {
                        NSLog("Index: \(index!)")
                        let paramDictionary:NSMutableDictionary = [:]
                        paramDictionary.addEntries(from: ["buzzer" : index])
                        //self.simpleMenager.sendAttribute(attributeelement: paramDictionary)
                        self.simpleMenager.setAttribute(controlParams: paramDictionary, cmdId: self.simpleMenager.getCmdId())
                    }
                }))
            }
        } else {
            for var colorName in ledColorArry {
                optionMenu.addAction(UIAlertAction(title: colorName, style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    let index = optionMenu.actions.index(of: alert)
                    if index != nil {
                        NSLog("Index: \(index!)")
                        let paramDictionary:NSMutableDictionary = [:]
                        paramDictionary.addEntries(from: ["led" : index])
                        self.simpleMenager.setAttribute(controlParams: paramDictionary, cmdId: self.simpleMenager.getCmdId())
                    }

                }))
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            //println("Cancelled")
        })
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func showLogin() {
        // 1.
        var usernameTextField: UITextField?
        var passwordTextField: UITextField?
        
        // 2.
        let alertController = UIAlertController(
            title: "Log in",
            message: "Please enter your Account",
            preferredStyle: UIAlertControllerStyle.alert)
        
        // 3.
        let loginAction = UIAlertAction(
        title: "Log in", style: UIAlertActionStyle.default) {
            (action) -> Void in
            
            if let username = usernameTextField?.text {
                print(" Username = \(username)")
            } else {
                print("No Username entered")
            }
            
            if let password = passwordTextField?.text {
                print("Password = \(password)")
            } else {
                print("No password entered")
            }
            
            HOST.userName = usernameTextField?.text
            HOST.password = passwordTextField?.text
            //for test
            let parameters: Parameters = [
                "username": HOST.userName,
                "password": HOST.password
            ]

            Alamofire.request(SERVER_MAIN_URL + LOGIN_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
                    debugPrint(response)
                    switch response.result
                    {
                    case .success:
                        if (response.result.value != nil) {
                            let JSON = response.result.value as! NSDictionary
                            let accessToken = JSON["accessToken"] as! String
                            print(accessToken)
                            self.getSupportSensor(token: accessToken as NSString)
                        }
                        print("LOGIN SUCCESS")
                        break
                    case .failure(let error):
                        print(error)
                        print("LOGIN FAIL")
                        self.reTrylogin()
                        break
                }
            }
        }
        
        alertController.addTextField {
            (txtUsername) -> Void in
            usernameTextField = txtUsername
            usernameTextField!.placeholder = "<Your username here>"
        }
        
        alertController.addTextField {
            (txtPassword) -> Void in
            passwordTextField = txtPassword
            //passwordTextField.secureTextEntry = true
            passwordTextField!.placeholder = "<Your password here>"
        }

        alertController.addAction(loginAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func reTrylogin() {

        let alert = UIAlertController(title: nil , message: "LOGIN FAIL", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
            self.showLogin()
        }))
        
        self.present(alert, animated: true)
    }
    
    func showAlert(title: NSString, message: NSString ) {
        
        let alert = UIAlertController(title: nil , message: message as String, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
            //self.showLogin()
        }))
        
        self.present(alert, animated: true)
    }

    func getSupportSensor(token: NSString){
        
        let headers: HTTPHeaders = [
            "Authorization": token as String,
            "Accept": "application/json"
        ]
        
        Alamofire.request(SERVER_MAIN_URL + ATTRIBUTE_CHECK_URL ,headers: headers).validate().responseJSON { response in
            debugPrint(response)
            switch response.result
            {
            case .success:
                if (response.result.value != nil) {
                    let result = response.result.value as! NSDictionary
                    let rows = result["rows"] as! NSDictionary
                    print(rows)
                    
                    if((rows.allKeys as NSArray).contains("Battery")){
                        self.tableView.isHidden = false;
                        
                        let supportSensorUIData = SensorUIData()
                        supportSensorUIData.Sensors.removeAll()
                        
                        for i in 0 ..< self.sensorUIData.Sensors.count {
                            let keyName = self.sensorUIData.Sensors[i].sensorName
                            if((rows.allKeys as NSArray).contains(keyName)){
                                let valueArry:NSArray = rows.object(forKey: keyName) as! NSArray
                                if(valueArry.count >= 1 ){
                                    let isSupport = valueArry[1] as! Bool
                                    self.sensorUIData.Sensors[i].sensorIsSupport = isSupport
                                    if (isSupport == true){
                                        supportSensorUIData.Sensors.append(self.sensorUIData.Sensors[i])
                                    }
                                }
                            }
                        }
                        self.sensorUIData = supportSensorUIData
                        
                        self.simpleMenager = SimpleManager(messageType: .TYPE_NONE)
                        self.simpleMenager.mqttConnect();
                        self.simpleMenager.delegate = self
                        
                        self.tableView.isHidden = false;
                    } else {
                        //need device app
                    }
                }
                print("getSupportSensor SUCCESS")
                break
            case .failure(let error):
                print(error)
                self.showAlert(title: "", message: error.localizedDescription as! NSString)
                print("getSupportSensor FAIL")
                //self.reTrylogin()
                break
            }
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensorUIData.Sensors.count
    }
    
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SensorTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "SensorCell") as? SensorTableViewCell
        
        var entry = sensorUIData.Sensors[indexPath.row]
        if( entry.sensorIsSupport == false){
            entry = sensorUIData.Sensors[indexPath.row + 1]
        }
        cell.cellImageView.image = entry.sensorImage
        cell.cellSensorNameLabel.text = entry.sensorName as String
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if(entry.sensorName == "Camera"){
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
            cell.cellSensorNameLabel.isUserInteractionEnabled = true
            cell.cellSensorNameLabel.addGestureRecognizer(tap)
        }
        
        //cell.ce
        
        //entry.sensorCategory = .ACTUATOR
        
        if(entry.sensorCategory == .ACTUATOR){
            cell.cellActiveSwitch.isHidden = true;
            cell.cellActiveButton.isHidden = false;
            cell.cellSensorValueLable.isHidden = true;
        } else{
            cell.cellActiveSwitch.isHidden = false;
            cell.cellActiveButton.isHidden = true;
            cell.cellSensorValueLable.isHidden = false;
        }
        
        //cell.cellSensorValueLable.text = entry.sensorValueString as String
        
        cell.cellActiveSwitch.tag = indexPath.row + 1
        cell.cellActiveSwitch.isOn = entry.sensorIsActivated
        cell.cellActiveSwitch.addTarget(self, action: #selector(switchAtValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
        cell.cellActiveButton.tag = indexPath.row + 1
        cell.cellActiveButton.addTarget(self, action: #selector(onCellButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        var stringValues: String = ""
        for i in 0 ..< entry.sensorValueName.count {
            var val: String = ""
            if( i == 0 ){
                val = "\(((entry.sensorValueFormat.object(at: i)) as AnyObject).object(at: 0)) : \(entry.sensorValueString[i])\(((entry.sensorValueFormat.object(at: i)) as AnyObject).object(at: 1))"
            } else {
                val = " \n\(((entry.sensorValueFormat.object(at: i)) as AnyObject).object(at: 0)) : \(entry.sensorValueString[i])\(((entry.sensorValueFormat.object(at: i)) as AnyObject).object(at: 1))"
            }
            stringValues += String(val)
        }
        //print("sensor var : \n\(stringValues)")
        cell.cellSensorValueLable.text = stringValues 

        return cell
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        if(self.decodedimage != nil){
            let imageVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
            imageVC.image = self.decodedimage
            self.present(imageVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let entry = sensorUIData.Sensors[indexPath.row]
        
        if(entry.sensorCategory != .ACTUATOR){
            return CGFloat(70 + (entry.sensorValueName.count * 30))
        } else {
            return CGFloat(70)
        }
    }
    
    @objc func update() {
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    
    //SimpleManagerDelegate
    func mqttDidReceiveMessage(result: NSDictionary) {
        print("mqttDidReceiveMessage")
        
        if(result.allKeys as NSArray).contains("result"){
            let resultTile:NSString = result.object(forKey: "result") as! NSString
            if (resultTile.isEqual(to: "fail") && (result.allKeys as! Array).contains("errorReason")) {
                let errorReason:NSString = result.object(forKey: "errorReason") as! NSString
                self.showAlert(title: "ERROR", message:errorReason)
                return
            }
        }
        
        if (result.allKeys as NSArray).contains("rpcRsp") {
            
            let rcpRsp:NSDictionary = result.object(forKey: "rpcRsp") as! NSDictionary
            
            if(rcpRsp.allKeys as NSArray).contains("error"){
                let errorDic:NSDictionary = rcpRsp.object(forKey: "error") as! NSDictionary
                if (errorDic.count > 0 ) {
                    self.showAlert(title: "ERROR", message: errorDic.object(forKey: "message")as! NSString)
                    return
                }
            }
            if(rcpRsp.allKeys as NSArray).contains("result")
            {
                let rcpRspResult:NSDictionary = rcpRsp.object(forKey: "result") as! NSDictionary
                if(rcpRspResult.allKeys as NSArray).contains("photo")
                {
                    let dataDecoded : Data = Data(base64Encoded: rcpRspResult.object(forKey: "photo") as! String, options: .ignoreUnknownCharacters)!
                    self.decodedimage = UIImage(data: dataDecoded)
                    let imageVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
                    imageVC.image = self.decodedimage
                    self.present(imageVC, animated: true, completion: nil)
                }
            }
        } else {
            for i in 0 ..< sensorUIData.Sensors.count {
                let entry = sensorUIData.Sensors[i]
                for k in 0 ..< entry.sensorValueName.count {
                    if(result.allKeys as NSArray).contains(entry.sensorValueName[k]){
                        let valueArry:NSArray = result.object(forKey: entry.sensorValueName[k]) as! NSArray
                        sensorUIData.Sensors[i].sensorValueString[k] = valueArry[1]
                        sensorUIData.Sensors[i].sensorIsActivated = true
                        break
                    }
                }
            }
        }
    }
    
    func mqttallSubscribed() {
        print("mqttallSubscribed")
        
        let subscribeDictionary:NSMutableDictionary = [:]
        let attributeArray: NSMutableArray = []
        let telemetryArray: NSMutableArray = []
        
        attributeArray.add("*")
        telemetryArray.add("*")
        
        subscribeDictionary.addEntries(from: ["cmd" : "enlist"])
        subscribeDictionary.addEntries(from: ["serviceName" : HOST.serviceName])
        subscribeDictionary.addEntries(from: ["deviceName" : HOST.deviceName])
        subscribeDictionary.addEntries(from: ["isTargetAll" : false])
        subscribeDictionary.addEntries(from: ["attribute" : attributeArray])
        subscribeDictionary.addEntries(from: ["telemetry" : telemetryArray])
        subscribeDictionary.addEntries(from: ["cmdId" : 1])
        
        simpleMenager.subscribe(subscribe: subscribeDictionary)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
}

