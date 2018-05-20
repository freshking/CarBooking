//
//  AppDelegate.swift
//  CarBooking
//
//  Created by Bastian Kohlbauer on 08.05.18.
//  Copyright © 2018 Bastian Kohlbauer. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // setup window
    let vc = ViewController()
    let nc = UINavigationController(rootViewController: vc)
    nc.navigationBar.tintColor = UIColor.secondary
    nc.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.secondary]
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = nc
    window?.makeKeyAndVisible()
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
    // Saves changes in the application's managed object context before the application terminates.
    self.saveContext()
  }

  // MARK: - Core Data stack
  
  lazy var managedObjectContext: NSManagedObjectContext = {
    
    //This resource is the same name as your xcdatamodeld contained in your project
    guard let modelURL = Bundle.main.url(forResource: "CarBooking", withExtension:"momd") else {
      fatalError("Error loading model from bundle")
    }
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
      fatalError("Error initializing mom from: \(modelURL)")
    }
    let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
    
    let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = psc
    
    guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
      fatalError("Unable to resolve document directory")
    }
    let storeURL = docURL.appendingPathComponent("CarBooking.sqlite")
    do {
      try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
    } catch {
      fatalError("Error migrating store: \(error)")
    }
    
    return managedObjectContext
  }()
  
  // MARK: - Core Data Saving support
  
  @discardableResult func saveContext() -> Bool {
    let context = managedObjectContext
    if context.hasChanges {
      do {
        try context.save()
        return true
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        let nserror = error as NSError
        print("Unresolved error \(nserror), \(nserror.userInfo)")
        return false
      }
    }
    return false
  }
}

