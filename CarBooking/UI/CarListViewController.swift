//
//  CarListViewController.swift
//  CarBooking
//
//  Created by Bastian Kohlbauer on 08.05.18.
//  Copyright © 2018 Bastian Kohlbauer. All rights reserved.
//

import UIKit

enum CarListingType {
  case cars
  case bookings
}

class CarListViewController: UIViewController {
  
  /// image cache provider
  private let imageCache = ContentCache<UIImage>()
  
  private var tableView: UITableView!
  
  /// type of car listings
  let listingType: CarListingType
  
  /// car object array
  var cars = [Car]() {
    didSet { tableView.reloadData() }
  }
  var refreshControl: UIRefreshControl!
  
  init(listingType: CarListingType) {
    self.listingType = listingType
    super.init(nibName: nil, bundle: nil)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.primary
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  /// setup view objects
  private func setupView() {
    if refreshControl == nil {
      refreshControl = UIRefreshControl()
    }
    if tableView == nil {
      tableView = UITableView(frame: view.bounds)
      tableView.backgroundColor = .clear
      tableView.delegate = self
      tableView.dataSource = self
      tableView.estimatedRowHeight = UITableViewAutomaticDimension
      tableView.register(CarCell.self, forCellReuseIdentifier: CarCell.identifier)
      tableView.refreshControl = refreshControl
      tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      view.addSubview(tableView)
    }
  }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension CarListViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cars.count
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let car = cars[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: CarCell.identifier, for: indexPath) as! CarCell
    cell.accessoryType = .disclosureIndicator
    // set image
    if let path = car.imagePath {
      imageCache.addObject(path: path) { [weak cell] (image) in
        cell?.imageView?.image = image
        cell?.setNeedsLayout()
      }
    } else {
      // TODO: remove once imagePath ist set in data. dont forget to remove ATS policy in Info.plist
      let path = "http://getdrawings.com/images/free-car-drawing-21.jpg"
      imageCache.addObject(path: path) { [weak cell] (image) in
        cell?.imageView?.image = image
        cell?.setNeedsLayout()
      }
    }
    // set name
    cell.textLabel?.text = car.name
    // set short description
    cell.detailTextLabel?.text = car.basicDescription
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let car = cars[indexPath.row]
    let vc = CarDetailsViewController(car: car)
    navigationController?.pushViewController(vc, animated: true)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
