//
//  ContentCache.swift
//  CarBooking
//
//  Created by Bastian Kohlbauer on 19.05.18.
//  Copyright © 2018 Bastian Kohlbauer. All rights reserved.
//

import UIKit

class ContentCache<T: AnyObject> {
  
  /// currently running fetches
  private var activeProviders = [RemoteProvider]()
  
  /// object data cache
  let cache = NSCache<AnyObject, T>()

  func addObject(path: String, completion: @escaping (T?) -> Void) {
    let key = path as AnyObject
    if let object = cache.object(forKey: key) {
      completion(object)
      return
    }
    let api = RemoteProvider(path: path)
    api.showIndicator = false
    api.execute { [weak self] (data, error) in
      if error != nil {
        completion(nil)
      } else {
        // TODO: expand type check conditions
        if let data = data {
          if T.self is UIImage.Type {
            if let image = UIImage(data: data) as? T {
              self?.cache.setObject(image, forKey: key)
              if let index = self?.activeProviders.index(where: { (_api) -> Bool in
                return _api.path == path
              }) {
                self?.activeProviders.remove(at: index)
              }
              completion(image)
              return
            }
          }
        }
        completion(nil)
      }
    }
    activeProviders.append(api)
  }
  
  func reset() {
    for api in activeProviders {
      api.cancel()
    }
    activeProviders.removeAll()
    cache.removeAllObjects()
  }
}
