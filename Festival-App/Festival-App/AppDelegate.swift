//
//  AppDelegate.swift
//  Festival-App
//
//  Created by Duminica Octavian on 21/02/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import UIKit
import CoreData
import Firebase

private struct Log {
    static let didRegisterForNotifications = "didRegisterForNotifications"
    static let didFailToRegisterForNotifications = "didFailToRegisterToNotifications"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.isStatusBarHidden = false
        
        //FirebaseApp.configure()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        UIApplication.shared.statusBarStyle = .lightContent
        
//        let rootController = storyboard.instantiateViewController(withIdentifier: Storyboard.ILoginViewController)
//        if let window = self.window {
//            window.rootViewController = rootController
//        }
//
//        if AuthService.shared.isLoggedIn {
//            switch AuthService.shared.user.type {
//            case "company":
//                guard let c = storyboard.instantiateViewController(withIdentifier: Storyboard.CMainViewController) as? CMainViewController else { return false }
//                if let window = self.window {
//                    window.rootViewController?.navigationController?.pushViewController(c, animated: false)
//                }
//            case "university":
//                guard let u = storyboard.instantiateViewController(withIdentifier: Storyboard.UMainViewController) as? UMainViewController else { return false }
//                if let window = self.window {
//                    window.rootViewController?.navigationController?.pushViewController(u, animated: false)
//                }
//            default:
//                guard let a = storyboard.instantiateViewController(withIdentifier: Storyboard.AMainViewController) as? AMainViewController else { return false }
//                if let root = self.window?.rootViewController {
//                    let navC = UINavigationController(rootViewController: root)
//                    navC.pushViewController(a, animated: false)
//                }
//            }
//        }
 
        
        NotificationService.shared.authorize()
        
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
        SocketService.shared.establishConnection()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        SocketService.shared.closeConnection()
        self.saveContext()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        AuthService.shared.deviceToken = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(AuthService.shared.deviceToken!)
        print(Log.didRegisterForNotifications)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(Log.didFailToRegisterForNotifications)
        
        print(error)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Festival_App")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

