//
//  ValueMapping.swift
//  CarBooking
//
//  Created by Bastian Kohlbauer on 08.05.18.
//  Copyright © 2018 Bastian Kohlbauer. All rights reserved.
//

/// operator declaration
infix operator <-

/// Maps right instance to left if of same type
///
/// - Parameters:
///   - left: instance to be mapped
///   - right: optional mapping value
func <- <T>(left: inout T, right: Any?) {
  if right is T {
    left = right as! T
  } else {
    ()
  }
}

/// Maps right instance to left if of same type
///
/// - Parameters:
///   - left: optional instance to be mapped
///   - right: optional mapping value
func <- <T>(left: inout T?, right: Any?) {
  left = right as? T
}
