//
//  Car.swift
//  CarBooking
//
//  Created by Bastian Kohlbauer on 08.05.18.
//  Copyright © 2018 Bastian Kohlbauer. All rights reserved.
//
//

import Foundation
import CoreData

class Car: NSManagedObject {
  @NSManaged public var basicDescription: String?
  @NSManaged public var fullDescription: String?
  @NSManaged public var id: Int64
  @NSManaged public var imagePath: String?
  @NSManaged public var name: String?
  @NSManaged public var booking: Booking?
}
