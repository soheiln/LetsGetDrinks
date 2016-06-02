//
//  VenueCollectionViewCell.swift
//  LetsGetDrinks
//
//  Created by soheiln on 5/31/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import Foundation
import UIKit

class VenueCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    var venue: Venue!
}
