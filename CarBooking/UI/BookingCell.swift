//
//  BookingCell.swift
//  CarBooking
//
//  Created by Bastian Kohlbauer on 08.05.18.
//  Copyright © 2018 Bastian Kohlbauer. All rights reserved.
//

import UIKit

class BookingCell: UITableViewCell {
  
  static let identifier = "BookingCell"
  
  /// minimum booking duration allowed
  private let minBookingDuration: TimeInterval = 3600*24
  
  /// maximum booking duration allowed
  private let maxBookingDuration: TimeInterval = 3600*24*7
  
  private var fromTitle: UILabel!
  private var toTitle: UILabel!
  
  var fromDatePicker: UIDatePicker!
  var toDatePicker: UIDatePicker!
  var bookingButton: UIButton!

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    translatesAutoresizingMaskIntoConstraints = false
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  /// setup view objects
  private func setupView() {
    let labelHeight: CGFloat = 30
    let pickerHeight: CGFloat = 80
    if fromTitle == nil {
      fromTitle = titleLabel()
      fromTitle.text = "Start date:"
      contentView.addSubview(fromTitle)
      fromTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding).isActive = true
      fromTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding).isActive = true
      fromTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true
      fromTitle.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
    }
    if fromDatePicker == nil {
      fromDatePicker = datePicker()
      fromDatePicker.date = Date().addingTimeInterval(minBookingDuration)
      fromDatePicker.addTarget(self, action: #selector(didSelectDate(picker:)), for: .valueChanged)
      contentView.addSubview(fromDatePicker)
      fromDatePicker.topAnchor.constraint(equalTo: fromTitle.bottomAnchor, constant: padding).isActive = true
      fromDatePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding).isActive = true
      fromDatePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true
      fromDatePicker.heightAnchor.constraint(equalToConstant: pickerHeight).isActive = true
    }
    if toTitle == nil {
      toTitle = titleLabel()
      toTitle.text = "End date:"
      contentView.addSubview(toTitle)
      toTitle.topAnchor.constraint(equalTo: fromDatePicker.bottomAnchor, constant: padding).isActive = true
      toTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding).isActive = true
      toTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true
      toTitle.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
    }
    if toDatePicker == nil {
      toDatePicker = datePicker()
      toDatePicker.date = fromDatePicker.date.addingTimeInterval(minBookingDuration)
      toDatePicker.addTarget(self, action: #selector(didSelectDate(picker:)), for: .valueChanged)
      contentView.addSubview(toDatePicker)
      toDatePicker.topAnchor.constraint(equalTo: toTitle.bottomAnchor, constant: padding).isActive = true
      toDatePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -padding).isActive = true
      toDatePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true
      toDatePicker.heightAnchor.constraint(equalToConstant: pickerHeight).isActive = true
    }
    if bookingButton == nil {
      bookingButton = UIButton(type: .custom)
      bookingButton.setTitle("Confirm Booking", for: .normal)
      bookingButton.setTitleColor(UIColor.accent, for: .normal)
      bookingButton.setTitleColor(UIColor.primary, for: .highlighted)
      bookingButton.translatesAutoresizingMaskIntoConstraints = false
      bookingButton.sizeToFit()
      contentView.addSubview(bookingButton)
      bookingButton.topAnchor.constraint(equalTo: toDatePicker.bottomAnchor, constant: padding).isActive = true
      bookingButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
      bookingButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true
    }
  }
}

//MARK:- Helper functions
extension BookingCell {
  
  /// Default title label
  ///
  /// - Returns: label
  private func titleLabel() -> UILabel {
    let label = UILabel()
    label.textColor = UIColor.secondary
    label.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
    label.adjustsFontSizeToFitWidth = true
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }
  
  /// Default date picker
  ///
  /// - Returns: picker
  private func datePicker() -> UIDatePicker {
    let picker = UIDatePicker()
    picker.calendar = Calendar.current
    picker.datePickerMode = .dateAndTime
    picker.locale = Locale.current
    picker.translatesAutoresizingMaskIntoConstraints = false
    picker.setValue(UIColor.secondary, forKeyPath: "textColor")
    return picker
  }
}

//MARK:- Picker actions
extension BookingCell {
  
  /// Upon changing values the pickers may be reset to min/max booking durations
  ///
  /// - Parameter picker: the picker who's value changed
  @objc private func didSelectDate(picker: UIDatePicker) {
    let now = Date()
    if picker == fromDatePicker {
      if fromDatePicker.date < now {
        fromDatePicker.date = now
      }
    }
    if picker == toDatePicker {
      let duration = toDatePicker.date.timeIntervalSince(fromDatePicker.date)
      if duration < minBookingDuration {
        toDatePicker.date = fromDatePicker.date.addingTimeInterval(minBookingDuration)
      } else if duration > maxBookingDuration {
        toDatePicker.date = fromDatePicker.date.addingTimeInterval(maxBookingDuration)
      }
    }
  }
}
