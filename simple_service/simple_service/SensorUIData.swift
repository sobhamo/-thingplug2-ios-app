//
//  SensorUIData.swift
//  simple_service
//
//  Created by SK Telecom on 2018. 1. 2..
//  Copyright © 2018년 SK Telecom. All rights reserved.
//

import Foundation
import UIKit


public enum SensorCategory: UInt8  {
    case SENSOR_MANAGER = 0
    case BROADCAST
    case LOCATION_MANAGER
    case MEDIA_RECORDER
    case ACTUATOR
}

class SensorUIData {
    class Entry {
        var sensorImage : UIImage
        var sensorName : NSString
        var sensorValueName : NSArray
        var sensorCategory : SensorCategory
        var sensorValueString : NSMutableArray
        var sensorValueFormat : NSArray
        var sensorIsActivated : Bool
        var sensorIsSupport : Bool
    
        
        init(sImage : UIImage, sName : NSString, sValueName : NSArray , sCategory :SensorCategory, sValueString : NSMutableArray, sValueFormat : NSArray , sActivated : Bool, sSupport : Bool) {
            self.sensorImage = sImage
            self.sensorName = sName
            self.sensorValueName = sValueName
            self.sensorCategory = sCategory
            self.sensorValueString = sValueString
            self.sensorValueFormat = sValueFormat
            self.sensorIsActivated = sActivated
            self.sensorIsSupport = sSupport
        }
    }
    
    var Sensors = [
        Entry(sImage: #imageLiteral(resourceName: "icon_batterygauge_big"), sName: "Battery", sValueName: ["batteryTemperature","batteryGuage"], sCategory: .BROADCAST, sValueString: ["0","0"], sValueFormat:[["Temperature", "℃"], ["Charge", "％"]], sActivated: false, sSupport: false),
        Entry(sImage: #imageLiteral(resourceName: "icon_temperature_big"), sName: "Temperature", sValueName: ["temperature"], sCategory: .SENSOR_MANAGER, sValueString: ["0"], sValueFormat:[["Ambient temperature", "℃"]], sActivated: false, sSupport: false),
        Entry(sImage: #imageLiteral(resourceName: "icon_humidity_big"), sName: "Humidity", sValueName: ["humidity"], sCategory: .SENSOR_MANAGER, sValueString: ["0"], sValueFormat:[["Air humidity", "%"]], sActivated: false, sSupport: false),
        Entry(sImage: #imageLiteral(resourceName: "icon_noise_big"), sName: "Noise", sValueName: ["noise"], sCategory: .MEDIA_RECORDER, sValueString: ["0"], sValueFormat:[["Noise", "㏈"]], sActivated: false, sSupport: false),
        Entry(sImage: #imageLiteral(resourceName: "icon_actuator_big"), sName: "GPS", sValueName: ["latitude", "longitude", "altitude"], sCategory: .LOCATION_MANAGER, sValueString: ["","",""], sValueFormat:[["Latitude", "˚"], ["Longitude","˚"], ["Altitude","˚"]], sActivated: false, sSupport: false),
        Entry(sImage: #imageLiteral(resourceName: "icon_pressure_big"), sName: "Air Pressure", sValueName: ["airPressure"], sCategory: .SENSOR_MANAGER, sValueString: ["0"], sValueFormat:[["Pressure", "h㎩"]], sActivated: false, sSupport: false),
        Entry(sImage: #imageLiteral(resourceName: "icon_light_big"), sName: "Light", sValueName: ["light"], sCategory: .SENSOR_MANAGER, sValueString: ["0"], sValueFormat:[["Level", "㏓"]], sActivated: false, sSupport: false),
        Entry(sImage: #imageLiteral(resourceName: "icon_buzzer_big"), sName: "Buzzer", sValueName: ["buzzer"], sCategory: .ACTUATOR, sValueString: ["0"], sValueFormat:[["",""]], sActivated: false, sSupport: false),
        Entry(sImage: #imageLiteral(resourceName: "icon_color_big"), sName: "Led", sValueName: ["led"], sCategory: .ACTUATOR, sValueString: ["0"], sValueFormat:[["",""]], sActivated: false, sSupport: false),
        Entry(sImage: #imageLiteral(resourceName: "icon_peoplecount_big"), sName: "Proximity", sValueName: ["distance"], sCategory: .SENSOR_MANAGER, sValueString: [""], sValueFormat:[["Distance", "㎝"]], sActivated: false, sSupport: false),
        Entry(sImage: #imageLiteral(resourceName: "icon_camera_big"), sName: "Camera", sValueName: ["camera"], sCategory: .ACTUATOR, sValueString: ["0"], sValueFormat:[["",""]], sActivated: false, sSupport: false),
        Entry(sImage: #imageLiteral(resourceName: "icon_accelerometer_big"), sName: "Accelerometer", sValueName: ["accel_x", "accel_y", "accel_z"], sCategory: .SENSOR_MANAGER, sValueString: ["0","0","0"], sValueFormat:[["X", "㎨"], ["Y", "㎨"], ["Z", "㎨"]], sActivated: false, sSupport: false),
        Entry(sImage: #imageLiteral(resourceName: "icon_windvane_big"), sName: "Orientation", sValueName: ["azi", "pitch", "roll"], sCategory: .SENSOR_MANAGER, sValueString: ["0","0","0"], sValueFormat:[["Azimuth", "˚"], ["Pitch", "˚"], ["Roll", "˚"]], sActivated: false, sSupport: false),
        Entry(sImage: #imageLiteral(resourceName: "icon_weight_big"), sName: "Gravity", sValueName: ["grav_x", "grav_y", "grav_z"], sCategory: .SENSOR_MANAGER, sValueString: ["0","0","0"], sValueFormat:[["X", "㎨"], ["Y", "㎨"], ["Z", "㎨"]], sActivated: false, sSupport: false),
        Entry(sImage: #imageLiteral(resourceName: "icon_rotaryangle_big"), sName: "Gyroscope", sValueName: ["gyro_x", "gyro_y", "gyro_z"], sCategory: .SENSOR_MANAGER, sValueString: ["0","0","0"], sValueFormat:[["X", "˚"], ["Y", "˚"], ["Z", "˚"]], sActivated: false, sSupport: false),
        Entry(sImage: #imageLiteral(resourceName: "icon_vibration_big"), sName: "Magnetic Field", sValueName: ["magn_x", "magn_y", "magn_z"], sCategory: .SENSOR_MANAGER, sValueString: ["0","0","0"], sValueFormat:[["X", "µT"], ["Y", "µT"], ["Z", "µT"]], sActivated: false, sSupport: false),
        Entry(sImage: #imageLiteral(resourceName: "icon_motion_on_big"), sName: "Step Detector", sValueName: ["stepDetection"], sCategory: .SENSOR_MANAGER, sValueString: ["0"], sValueFormat:[["Detection", ""]], sActivated: false, sSupport: false),
        Entry(sImage: #imageLiteral(resourceName: "icon_motion_on_big"), sName: "Step Count", sValueName: ["stepCount"], sCategory: .SENSOR_MANAGER, sValueString: ["0"], sValueFormat:[["Count", "steps"]], sActivated: false, sSupport: false)
    ]
}
