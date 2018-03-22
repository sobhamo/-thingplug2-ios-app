//
//  SensorTableViewCell.swift
//  simple_service
//
//  Created by SK Telecom on 2018. 1. 2..
//  Copyright © 2018년 SK Telecom. All rights reserved.
//

import UIKit

class SensorTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellSensorNameLabel: UILabel!
    @IBOutlet weak var cellActiveSwitch: UISwitch!
    @IBOutlet weak var cellActiveButton: UIButton!
    @IBOutlet weak var cellSensorValueLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onSwitchClick(_ sender: UISwitch) {
        //let value = sender.isOn
    }
    @IBAction func onButtonClick(_ sender: UIButton) {
        
    }
}
