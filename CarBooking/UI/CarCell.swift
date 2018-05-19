//
//  CarCell.swift
//  CarBooking
//
//  Created by Bastian Kohlbauer on 08.05.18.
//  Copyright © 2018 Bastian Kohlbauer. All rights reserved.
//

import UIKit

class CarCell: UITableViewCell {
  
  static let identifier = "CarCell"

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if let imageView = imageView {
      imageView.layer.cornerRadius = min(imageView.bounds.width, imageView.bounds.height)/2.0
    }
  }
  
  /// setup view objects
  private func setupView() {
    textLabel?.textColor = UIColor.primary
    detailTextLabel?.textColor = UIColor.secondary
    imageView?.contentMode = .scaleAspectFill
    imageView?.layer.masksToBounds = true
  }
}
