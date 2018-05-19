//
//  DatabaseProvider.swift
//  CarBooking
//
//  Created by Bastian Kohlbauer on 08.05.18.
//  Copyright © 2018 Bastian Kohlbauer. All rights reserved.
//

import UIKit
import CoreData

class DatabaseProvider {
  
  /// applications delegate
  private let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
  /// saves context changes
  @discardableResult func save() -> Bool {
    return appDelegate.saveContext()
  }
  
  /// Tries to fetch and return first instance of the `NSManagedObject`
  ///
  /// - Parameter predicate: the predicate of the fetch request
  /// - Returns: the first `NSManagedObject` instance that satisfies the predicate
  func fetchOne<T: NSManagedObject>(predicate: NSPredicate?) -> T? {
    return fetchAll(predicate: predicate)?.first
  }
  
  /// Tries to fetch and return all instances of the `NSManagedObject`
  ///
  /// - Parameter predicate: the predicate of the fetch request
  /// - Returns: all the `NSManagedObject` instances that satisfy the predicate
  func fetchAll<T: NSManagedObject>(predicate: NSPredicate? = nil) -> [T]? {
    let context = appDelegate.persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName())
    request.predicate = predicate
    do {
      let result = try context.fetch(request)
      return result as? [T]
    } catch let error {
      print(error.localizedDescription)
    }
    return nil
  }
  
  /// Tries to insert an instance of `NSManagedObject` into DB and returns it if successful
  ///
  /// - Parameter values: key value pairs that should ba added to the `NSManagedObject` instance
  /// - Returns: successfully inserted instance of `NSManagedObject`
  func insertOne<T: NSManagedObject>() -> T? {
    let context = appDelegate.persistentContainer.viewContext
    guard let entity = NSEntityDescription.entity(forEntityName: T.entityName(), in: context) else {
      return nil
    }
    let object = T(entity: entity, insertInto: context)
    if save() {
      return object
    }
    return nil
  }
}
