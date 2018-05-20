//
//  CarDescriptionCell.swift
//  CarBooking
//
//  Created by Bastian Kohlbauer on 08.05.18.
//  Copyright © 2018 Bastian Kohlbauer. All rights reserved.
//

import UIKit

class CarDescriptionCell: UITableViewCell {
  
  static let identifier = "CarDescriptionCell"

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// setup view objects
  private func setupView() {
    textLabel?.textColor = UIColor.primary
    detailTextLabel?.textColor = UIColor.secondary
    detailTextLabel?.numberOfLines = 0
  }
}
