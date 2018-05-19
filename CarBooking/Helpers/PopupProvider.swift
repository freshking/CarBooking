//
//  PopupProvider.swift
//  CarBooking
//
//  Created by Bastian Kohlbauer on 08.05.18.
//  Copyright © 2018 Bastian Kohlbauer. All rights reserved.
//

import UIKit

class PopupProvider {
  
  /// Shows a basic popup
  ///
  /// - Parameters:
  ///   - title: Popup title
  ///   - message: Popup message
  ///   - buttonText: Popup confirmation button text
  static func show(title: String?, message: String?, buttonText: String = "OK") {
    let popup = UIAlertController(title: title, message: message, preferredStyle: .alert)
    popup.addAction(UIAlertAction(title: buttonText, style: .cancel, handler: nil))
    UIApplication.shared.windows.first?.rootViewController?.present(popup, animated: true, completion: nil)
  }
}
