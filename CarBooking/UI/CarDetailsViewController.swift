//
//  CarDetailsViewController.swift
//  CarBooking
//
//  Created by Bastian Kohlbauer on 08.05.18.
//  Copyright © 2018 Bastian Kohlbauer. All rights reserved.
//

import UIKit

class CarDetailsViewController: UIViewController {
  
  /// car object
  private let car: Car
  
  /// database provider
  private let db = DatabaseProvider()
  
  /// image cache provider
  private let imageCache = ContentCache<UIImage>()
  
  private var tableView: UITableView!
  private var allowBooking: Bool {
    return car.booking == nil
  }
  
  /// init method
  init(car: Car) {
    self.car = car
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.primary
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    setupView()
  }

  /// setup view objects
  private func setupView() {
    if tableView == nil {
      tableView = UITableView(frame: view.bounds)
      tableView.backgroundColor = .clear
      tableView.delegate = self
      tableView.dataSource = self
      tableView.estimatedRowHeight = UITableViewAutomaticDimension
      tableView.register(CarCell.self, forCellReuseIdentifier: CarCell.identifier)
      tableView.register(BookingCell.self, forCellReuseIdentifier: BookingCell.identifier)
      tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      view.addSubview(tableView)
    }
  }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension CarDetailsViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    var count = 1
    if allowBooking {
      count += 1
    }
    return count
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      // car cell
      let cell = tableView.dequeueReusableCell(withIdentifier: CarCell.identifier, for: indexPath) as! CarCell
      cell.selectionStyle = .none
      cell.accessoryType = .none
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
      var text: String
      if let description = car.fullDescription ?? car.basicDescription {
        text = description
      } else {
        text = ""
      }
      if let booking = car.booking {
        if text == "" {
          text = "Booked"
        } else {
          text += "\n\n" + "Booked"
        }
        if let startDate = booking.startDate, let endDate = booking.endDate {
          let formatter = DateFormatter()
          formatter.calendar = Calendar.current
          formatter.timeZone = TimeZone.current
          formatter.timeStyle = .medium
          formatter.dateStyle = .long
          text += " from \(formatter.string(from: startDate)) to \(formatter.string(from: endDate))"
        }
      }
      let attr = NSMutableAttributedString(string: text,
                                           attributes: [NSAttributedStringKey.foregroundColor: UIColor.secondary,
                                                        NSAttributedStringKey.font: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)])
      cell.detailTextLabel?.attributedText = attr
      cell.detailTextLabel?.numberOfLines = 0
      return cell
    case 1:
      // booking cell
      let cell = tableView.dequeueReusableCell(withIdentifier: BookingCell.identifier, for: indexPath) as! BookingCell
      cell.bookingButton.addTarget(self, action: #selector(bookingButtonAction), for: .touchUpInside)
      return cell
    default:
      return UITableViewCell()
    }
  }
}

//MARK:- Button actions
extension CarDetailsViewController {
  
  /// add/update car booking object
  @objc private func bookingButtonAction() {
    if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? BookingCell {
      // add booking data
      var booking = car.booking
      if booking == nil {
        booking = db.insertOne()
      }
      if let booking = booking {
        booking.startDate = cell.fromDatePicker.date
        booking.endDate = cell.toDatePicker.date
      }
      car.booking = booking
      let success = db.save()
      switch success {
      case true:
        let name = car.name ?? "car"
        PopupProvider.show(title: "Success", message: "Successfully booked" + " \(name).")
      case false:
        PopupProvider.show(title: "Error", message: defaultError)
      }
      tableView.reloadData()
    }
  }
}
