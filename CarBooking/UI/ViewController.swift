//
//  ViewController.swift
//  CarBooking
//
//  Created by Bastian Kohlbauer on 08.05.18.
//  Copyright © 2018 Bastian Kohlbauer. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {
  
  /// database provider
  private let db = DatabaseProvider()
  
  /// remote content provider
  private var api: RemoteProvider?

  /// boolean stating initial data fetching
  private var didCollectData: Bool = false
  private var currentViewController: CarListViewController? {
    return selectedViewController as? CarListViewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.primary
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    tabBar.tintColor = UIColor.secondary
    setupView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if didCollectData == false {
      didCollectData = true
      fetchData()
    } else {
      updateData()
    }
  }

  /// setup view objects
  private func setupView() {
    // viewControllers
    let carsVC = CarListViewController(listingType: .cars)
    carsVC.refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
    carsVC.title = "Cars"
    carsVC.tabBarItem = UITabBarItem(title: carsVC.title, image: #imageLiteral(resourceName: "icons8-bulleted-list"), tag: 0)
    carsVC.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.secondary], for: .selected)
    let bookingsVC = CarListViewController(listingType: .bookings)
    bookingsVC.refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
    bookingsVC.title = "Bookings"
    bookingsVC.tabBarItem = UITabBarItem(title: bookingsVC.title, image: #imageLiteral(resourceName: "icons8-ticket-purchase"), tag: 1)
    bookingsVC.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.secondary], for: .selected)
    setViewControllers([carsVC, bookingsVC], animated: false)
    selectedViewController = carsVC
    title = carsVC.tabBarItem.title
  }

  /// set title according to tab bar item title
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    title = item.title
  }
  
  /// load object from endpoint, parse data, create db object and insert if necessary
  @objc private func fetchData() {
    api?.cancel()
    api = RemoteProvider(path: "http://job-applicants-dummy-api.kupferwerk.net.s3.amazonaws.com/api/cars.json")
    api?.execute { [weak self] (data, error) in
      // hide refresh control
      self?.currentViewController?.refreshControl.endRefreshing()
      // handle response
      if let error = error {
        PopupProvider.show(title: "Error", message: error)
      } else {
        if let data = data {
          do {
            let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .allowFragments])
            if let json = json as? [Dictionary<String, Any>] {
              for dict in json {
                if let id = dict["id"] as? Int64 {
                  let predicate = NSPredicate(format: "id == %i", id)
                  var car: Car? = self?.db.fetchOne(predicate: predicate)
                  if car ==  nil {
                    // car does not exist in db. insert new one.
                    car = self?.db.insertOne()
                  }
                  if let car = car {
                    car.id = id
                    car.name <- dict["name"]
                    car.basicDescription <- dict["shortDescription"]
                    car.fullDescription <- dict["description"]
                    car.imagePath <- dict["image"]
                  }
                }
              }
              // save db changes
              self?.db.save()
              // update cars list
              self?.updateData()
            } else {
              PopupProvider.show(title: "Error", message: "Data format error.")
            }
          } catch let error {
            PopupProvider.show(title: "Error", message: error.localizedDescription)
          }
        } else {
          PopupProvider.show(title: "Error", message: "No data found.")
        }
      }
    }
  }
  
  /// update view controlers cars array
  private func updateData() {
    guard let viewControllers = viewControllers as? [CarListViewController]  else {
      return
    }
    let cars: [Car] = db.fetchAll() ?? []
    for vc in viewControllers {
      switch vc.listingType {
      case .cars:
        // show only cars which can be booked
        vc.cars = (cars.filter {$0.booking == nil}).sorted(by: { (lhs, rhs) -> Bool in
          return lhs.name ?? "" < rhs.name ?? ""
        })
      case .bookings:
        // show only cars thats have been booked
        vc.cars = (cars.filter {$0.booking != nil}).sorted(by: { (lhs, rhs) -> Bool in
        return lhs.name ?? "" < rhs.name ?? ""
        })
      }
      // update tab bar badges
      if vc.cars.count > 0 {
        vc.tabBarItem.badgeValue = String(vc.cars.count)
      } else {
        vc.tabBarItem.badgeValue = nil
      }
    }
  }
}
