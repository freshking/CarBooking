//
//  RemoteProvider.swift
//  CarBooking
//
//  Created by Bastian Kohlbauer on 08.05.18.
//  Copyright © 2018 Bastian Kohlbauer. All rights reserved.
//

import UIKit

class RemoteProvider {
  
  /// alert acting as an loading indicator
  private var alert: UIAlertController?
  
  /// data task session
  private var session: URLSessionDataTask?
  
  /// show/hide laoding indicator during fetching
  var showIndicator: Bool = true
  
  /// endpoint path
  let path: String
  
  init(path: String) {
    self.path = path
  }
  
  /// Loads a resource from the given path
  ///
  /// - Parameter completion: returns any data or error message after request completed
  func execute(completion: @escaping (_ data: Data?, _ error: String?) -> Void) {
    guard let url = URL(string: path) else {
      completion(nil, "Error producing URL")
      return
    }
    // setup alert overlay
    if showIndicator == true && alert == nil {
      alert = UIAlertController(title: "Fetching data…", message: nil, preferredStyle: .alert)
      alert?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] (action) in
        self?.session?.cancel()
        completion(nil, "Request cancelled")
      }))
      UIApplication.shared.windows.first?.rootViewController?.present(alert!, animated: true, completion: nil)
    }
    // reset
    session?.cancel()
    // fetch data
    session = URLSession.shared.dataTask(with: url) { (data, response, error) in
      func finish(_ data: Data?, _ error: String?) {
        OperationQueue.main.addOperation {
          if let alert = self.alert {
            alert.dismiss(animated: true, completion: {
              completion(data, error)
            })
          } else {
            completion(data, error)
          }
        }
      }
      if let error = error {
        finish(nil, error.localizedDescription)
      } else {
        if let data = data {
          finish(data, nil)
        } else {
          finish(nil, "No data found.")
        }
      }
    }
    session?.resume()
  }
  
  /// cancels any active session
  func cancel() {
    session?.cancel()
  }
}
