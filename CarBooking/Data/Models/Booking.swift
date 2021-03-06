//
//  Booking.swift
//  CarBooking
//
//  Created by Bastian Kohlbauer on 19.05.18.
//  Copyright © 2018 Bastian Kohlbauer. All rights reserved.
//

import Foundation
import CoreData

/// object in which all booking data for a car is stored
class Booking: NSManagedObject {
  @NSManaged public var endDate: Date?
  @NSManaged public var startDate: Date?
  @NSManaged public var car: Car?
}
