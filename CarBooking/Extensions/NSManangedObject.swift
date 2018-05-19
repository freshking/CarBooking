//
//  NSManangedObject.swift
//  CarBooking
//
//  Created by Bastian Kohlbauer on 19.05.18.
//  Copyright © 2018 Bastian Kohlbauer. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
  
  /// Derives the NSMangedModel entity name from the subclass name.
  ///
  /// - Returns: The NSMangedModel subclass name as a string
  static func entityName() -> String {
    return String(describing: self)
    //let className = String(self).characters.dropFirst(2)
    //return String(className)
  }
}
