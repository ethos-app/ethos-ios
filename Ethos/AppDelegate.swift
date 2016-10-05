//
//  AppDelegate.swift
//  Ethos
//
//  Created by Scott Fitsimones on 8/30/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import PushKit
import UserNotifications
import BRYXBanner
import Fabric
import Crashlytics

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, FIRMessagingDelegate {
    /// The callback to handle data message received via FCM for devices running iOS 10 or above.
    var window: UIWindow?
    var post = 0
    var banner = Banner()
    // Receive displayed notifications for iOS 10 devices.
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter,
                                willPresentNotification notification: UNNotification,
                                withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        print("%@", userInfo)
        
        
        
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print("%@", remoteMessage.appData)
        print("REMOTE PUSH")
    
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // Get info form notification 
        let dict = userInfo as NSDictionary
        let pre = dict.object(forKey: "aps") as! NSDictionary
        let alert = pre.object(forKey: "alert") as! NSDictionary
        let title = alert.object(forKey: "title") ?? ""
        let body = alert.object(forKey: "body") ?? ""

        // Create Banner to show
        let bannerColor  = UIColor.hexStringToUIColor("fdb321").withAlphaComponent(0.95)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.show))
        banner = Banner(title: "\(title)", subtitle: "\(body)", image: UIImage(named: "Icon"), backgroundColor: bannerColor)
        banner.textColor = UIColor.white
        banner.dismissesOnTap = true
        banner.addGestureRecognizer(tapGesture)
        
        if let postNumber = dict.object(forKey: "postId") as? String {
            let postInt = Int(postNumber)
            self.post = postInt!
            if application.applicationState == UIApplicationState.active {
            // if active, show banner
            banner.show(duration: 3.5)
            } else {
            // background, show push right when we launch
            showPushInfo(postID: postInt!)
            }
        }
        
        
    }
    func show() {
        showPushInfo(postID: post)
    }
    func showPushInfo(postID: Int) {
        banner.dismiss()
        print("SHOW POST")
        print(postID)
        if postID != 0 {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let postController = storyboard.instantiateViewController(withIdentifier: "single") as! OneCardViewController
        postController.postID = postID
      
            if let controller = self.window?.rootViewController as? UITabBarController {
            print("SHOWING")
            let index = controller.selectedViewController as! UINavigationController
            index.pushViewController(postController, animated: true)
            }
        }
    }
 
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        self.window?.tintColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor.hexStringToUIColor("247BA0").withAlphaComponent(0.8)
        UITabBar.appearance().barTintColor = UIColor.hexStringToUIColor("F3F3F3")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "launch"), object: nil)
        FIRApp.configure()
               if #available(iOS 10.0, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            application.registerForRemoteNotifications()
            
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [ .alert , .badge , .sound], categories: nil))
            
        } else {
            // Fallback on earlier versions
            
            
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification(notification:)), name: NSNotification.Name(rawValue: "kFIRInstanceIDTokenRefreshNotification"), object: nil)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        Fabric.with([Crashlytics.self])
        Fabric.with([Answers.self])
        Fabric.sharedSDK().debug = true

        // Override point for customization after application launch.
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            
            
            
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    
    func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
            
        }
        
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: .sandbox)
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.applicationIconBadgeNumber = 0
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

