//
//  Constants.swift
//  LetsGetDrinks
//
//  Created by soheiln on 5/26/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import Foundation

class Constants {
    
    struct GoogleAPI {
        static let placeSearchMethodURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        static let placeDetailsMethodURL = "https://maps.googleapis.com/maps/api/place/details/json?"
        static let placePhotoMethodURL = "https://maps.googleapis.com/maps/api/place/photo?"
        static let apiKey = "AIzaSyB76u_0lqPeUPSWCyH0Lr5zp7GExa5Rc_Q"
        static let radiusOfSearch = "2000"
        static let photoMaxWidth = "400"
    }
    
    struct UberAPI {
        static let client_id = "JQ1OM-ubUwWlWqDQ8Jdbjjj80BXPkcY5"
    }
    
    struct CollectionView {
        static let NumSectionsInPortraitMode = 2.0
        static let NumSectionsInLandscapeMode = 4.0
        static let SpaceBetweenSections = 3.0
    }
    
    struct MapView {
        static let latitudeRegion = 0.1
        static let longitudeRegion = 0.1
    }
    
    struct OverlayView {
        static let horizontalPadding = 60.0
        static let verticalPadding = 120.0
    }
    
    static let num_photos_in_new_collection = 16
    static let MinimumPressDuration = 1.0
    
    static let autoSaveDelayInSeconds = 20

}