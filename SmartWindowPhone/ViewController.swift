//
//  ViewController.swift
//  SmartWindowPhone
//
//  Created by Rohan Tanna on 7/14/15.
//  Copyright (c) 2015 TI Interns. All rights reserved.
//

import UIKit
import Moscapsule

class ViewController: UIViewController {

    
    
    @IBOutlet weak var automaticButton: UIButton!
    @IBOutlet weak var manualButton: UIButton!
    @IBOutlet weak var tintStepper: UIStepper!
    @IBOutlet weak var brightnessLabel: UILabel!
    @IBOutlet weak var tintLabel: UILabel!
    @IBOutlet weak var seasonButton: UISwitch!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var backgroundView: UIImageView!
    
    @IBOutlet weak var symbol: UIImageView!
    
    
    let white = UIColor.whiteColor()
    let pressed = UIControlState.Highlighted
    let gray = UIColor.grayColor()
    let magenta = UIColor.magentaColor()
    let red = UIColor.redColor()
    let yellow = UIColor.yellowColor()
    
    @IBOutlet weak var symbolDistance: NSLayoutConstraint!
    
    
    
  //  var packageObject = iOSObject()
    var packageDict:[String: String] = ["winterMode": "false", "summerMode": "true", "automaticMode": "false", "manualMode": "true", "manualVal": "100"]
    
    
    let t = MQTTConfig(clientId: "boobs", host: "iot.eclipse.org", port: 1883, keepAlive: 100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //configure wireless
        t.onPublishCallback = { messageId in
            NSLog("published (mid=\(messageId))")
        }
        
        t.onMessageCallback =  { mqttMessage in
            NSLog("MQTT Message received: payload=\(mqttMessage.payloadString)")
        }
        
       // mqttClient.disconnect()
        tintStepper.value = 100
        brightnessLabel.text = String(Int(tintStepper.value))
        
        manualButton.setTitleColor(white, forState: UIControlState.Selected)
        automaticButton.setTitleColor(white, forState: UIControlState.Selected)
        
        manualButton.selected = true
        automaticButton.selected = false
        
        tintStepper.tintColor = red
        
        seasonLabel.text = "Summer Mode"
        seasonButton.on = false
        
        backgroundView.image = UIImage(named: "summerBackground")
        
        self.symbolDistance.constant = 247

        
        
        
        
//manualButton.setBackgroundImage(UIImage(named: "sun"), forState: UIControlState.Selected)
//automaticButton.setBackgroundImage(UIImage(named: "sun"), forState: UIControlState.Selected)
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func manualPressed(sender: AnyObject) {
        
        manualButton.selected = true
        automaticButton.selected = false
        
        tintLabel.enabled = true
        brightnessLabel.enabled = true
        tintStepper.enabled = true
        
        packageDict["automaticMode"] = "false"
        packageDict["manualMode"] = "true"
        
        tintStepper.tintColor = red
        
        var package:String = JSONStringify(packageDict)

        
        let mqttClient = MQTT.newConnection(t)
        
        mqttClient.publishString(package, topic: "iOSInput", qos: 1, retain: true)
        mqttClient.subscribe("iOSInput", qos: 1)
        
        UIView.animateWithDuration(0.2, animations: {
        
           self.symbolDistance.constant = 247
            self.view.layoutIfNeeded()
            
        })
    }
    
    
    @IBAction func automaticPressed(sender: AnyObject) {
        manualButton.selected = false
        automaticButton.selected = true
        
        tintLabel.enabled = false
        brightnessLabel.enabled = false
        tintStepper.enabled = false
        
        packageDict["automaticMode"] = "true"
        packageDict["manualMode"] = "false"
        
        tintStepper.tintColor = gray
        
        var package:String = JSONStringify(packageDict)
        
        
        let mqttClient = MQTT.newConnection(t)
        
        mqttClient.publishString(package, topic: "iOSInput", qos: 1, retain: true)
        mqttClient.subscribe("iOSInput", qos: 1)


        
        
        UIView.animateWithDuration(0.2, animations: {
            
            self.symbolDistance.constant = 35
            self.view.layoutIfNeeded()
            
        })
    }
   
    
    
    @IBAction func stepperPresssed(sender: AnyObject) {
        
        packageDict["manualVal"] = String(Int(tintStepper.value))
        
        var package:String = JSONStringify(packageDict)
        
        
        brightnessLabel.text = String(Int(tintStepper.value))
        
        let mqttClient = MQTT.newConnection(t)
        
        mqttClient.publishString(package, topic: "iOSInput", qos: 1, retain: true)
        mqttClient.subscribe("iOSInput", qos: 1)
        
    }
    
    
    @IBAction func seasonChange(sender: AnyObject) {
        
        if (seasonButton.on == true){
            packageDict["winterMode"] = "true"
            packageDict["summerMode"] = "false"
            seasonLabel.text = "Winter Mode"
            backgroundView.image = UIImage(named: "winterBackground")
            
          //  manualButton.setBackgroundImage(UIImage(named: "snowflake"), forState: UIControlState.Selected)
            //automaticButton.setBackgroundImage(UIImage(named: "snowflake"), forState: UIControlState.Selected)
            symbol.image = UIImage(named: "snowflake")

            

        }
        else{
            packageDict["winterMode"] = "false"
            packageDict["summerMode"] = "true"
            seasonLabel.text = "Summer Mode"
            backgroundView.image = UIImage(named: "summerBackground")
            
         //   manualButton.setBackgroundImage(UIImage(named: "sun"), forState: UIControlState.Selected)
          //  automaticButton.setBackgroundImage(UIImage(named: "sun"), forState: UIControlState.Selected)
            symbol.image = UIImage(named: "sun")

            
        }
        
        var package:String = JSONStringify(packageDict)
        
        
        let mqttClient = MQTT.newConnection(t)
        
        mqttClient.publishString(package, topic: "iOSInput", qos: 1, retain: true)
        mqttClient.subscribe("iOSInput", qos: 1)
    }


}

