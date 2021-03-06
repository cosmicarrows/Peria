//
//  ViewController.swift
//  Peria
//
//  Created by Laurence Wingo on 6/16/18.
//  Copyright © 2018 Cosmic Arrows, LLC. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    @IBOutlet var copyrightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view animation code
        let delay = 4.2 // time in seconds
        Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(animatedViewBackground), userInfo: nil, repeats: true)
        //end of view animation code
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func animatedViewBackground(){
        UIView.animateKeyframes(withDuration: 4.0, delay: 0.0, options: .allowUserInteraction, animations: {
            self.view.backgroundColor = self.generateRandomColor()
            self.copyrightLabel.textColor = self.generateRandomColor()
        }, completion: nil)
    }
    
    func generateRandomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.8 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }


}

extension ViewController: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //play sound and show alert to the user
        completionHandler([.alert, .sound])
        
        print("notificaiton delivered while app is in the foreground on the appointment screen")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("did receive response from user while the notification was presented!")
        
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "VisitNostalgiaWebsite":
            print("add code here to open a browser to direct the user to the website")
        case "Delete":
            print("Delete")
        default:
            print("Uknown action")
        }
        completionHandler()
    }
}


