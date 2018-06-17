//
//  AppDelegate.swift
//  Peria
//
//  Created by Laurence Wingo on 6/16/18.
//  Copyright © 2018 Cosmic Arrows, LLC. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let notificationDelegate = ViewController()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     
        //shared UNUserNotificationCenter object
        let center = UNUserNotificationCenter.current()
        //set the delegate of the center
        center.delegate = notificationDelegate as UNUserNotificationCenterDelegate
        
        //notification type for this app
        let notificationOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        //make an authorization request using the UNUserNotificationCenter object
        center.requestAuthorization(options: notificationOptions) { (granted, error) in
            if !granted {
                print("Something went terribly wrong because the user turned down allowing notifications")
            }
        }
        
        //creating a notification request which contains the CONTENT and the TRIGGER!
        let content = UNMutableNotificationContent.init()
        
        //content
        content.title = "Morning Affirmation"
        content.body = "You cannot love until you live the life you love!"
        content.sound = UNNotificationSound.init(named: "skorpid.mp3")
        
        //trigger
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 50, repeats: false)
        
        //string identifier needed for future reference to refer to the request we're setting up
        let identifier = "UYLLocalNotification"
        
        //create the request to pass back to the center
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        
        //add the request to the center
        center.add(request) { (error) in
            if let error = error {
                print("Something went wrong with the notification request being added to the notification center")
            }
        }
        
        //adding two actions to the notification for the user to interact with the notification
        let snoozeAction = UNNotificationAction.init(identifier: "VisitNostalgiaWebsite", title: "Get New Features", options: [])
        let deleteAction = UNNotificationAction.init(identifier: "UYLDeleteAction", title: "Delete", options: [.destructive])
        
        //creating a category for the actions
        let category = UNNotificationCategory.init(identifier: "UYLReminderCategory", actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
        
        //register the category with the notification center
        center.setNotificationCategories([category])
        
        //set the category in the notification content
        content.categoryIdentifier = "UYLReminderCategory"
        
        
        FirebaseApp.configure()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Messaging.messaging().apnsToken = deviceToken
        
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    
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

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        print("Firebase Cloud Messaging token received...")
        let token = Messaging.messaging().fcmToken
        print("Firebase Cloud Messaging token: \(token ?? "")")
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
        
    }
}

