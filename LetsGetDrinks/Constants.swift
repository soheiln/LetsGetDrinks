//
//  Constants.swift
//  LetsGetDrinks
//
//  Created by soheiln on 5/26/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import Foundation

class Constants {
    
    struct YelpAPI {
        static let methodURL = "https://api.yelp.com/v2/search?term=bar&cll="
        static let consumerKey = "O_bBt7tm49oMKjn7YG4NXw"
        static let consumerSecret = "StI9V-2aGxiJtrPZx6JnhHCKWlo"
        static let token = "73xdOlAkjeCDWWFQnTo2MzCHezKqFutf"
        static let tokenSecret = "cap8_wQEuteT3hZSTecifSk0Yzs"
    }
    
    struct CollectionView {
        static let NumSectionsInPortraitMode = 2.0
        static let NumSectionsInLandscapeMode = 4.0
        static let SpaceBetweenSections = 3.0
    }
    static let num_photos_in_new_collection = 16
    static let MinimumPressDuration = 1.0
    
    static let autoSaveDelayInSeconds = 20

}