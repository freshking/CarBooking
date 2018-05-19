//
//  UIColorExtensions.swift
//  CarBooking
//
//  Created by Bastian Kohlbauer on 08.05.18.
//  Copyright © 2018 Bastian Kohlbauer. All rights reserved.
//

import UIKit

extension UIColor {
  
  /// Application primary color (172, 207, 204)
  static var primary: UIColor {
    return UIColor(hexString: "ACCFCC")
  }
  
  /// Application secondary color (89, 82, 65)
  static var secondary: UIColor {
    return UIColor(hexString: "595241")
  }
  
  /// Application accent color (172, 207, 204)
  static var accent: UIColor {
    return UIColor(hexString: "8A0917")
  }
  
  /// Initialies the object with the help of a hex string
  ///
  /// - Parameter hexString: Color in as HEX string representation
  convenience init(hexString: String) {
    let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int = UInt32()
    Scanner(string: hex).scanHexInt32(&int)
    let a, r, g, b: UInt32
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (255, 0, 0, 0)
    }
    self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
  }
}
