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
    
    // method to call after the venue property is loaded
    func initView() {
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.text = venue.name
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        if let photo = venue.photo {
            imageView.image = UIImage(data: photo)
        } else {
            imageView.image = UIImage(named: "no_image_available")
        }
    }
    
}
