//
//  UberClient.swift
//  LetsGetDrinks
//
//  Created by soheiln on 6/6/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import Foundation
import MapKit

class UberClient {
    
    static func constructUberURLForLocation(venue: Venue, universalLink: Bool) -> NSURL? {
        var uberURL: String
        uberURL = universalLink == false ? "uber://" : "https://m.uber.com/ul"
        
        uberURL += "?client_id=" + Constants.UberAPI.client_id
        uberURL += "&action=setPickup"
        uberURL += "&pickup=my_location"        
        uberURL += "&dropoff[latitude]=\(venue.latitude)"
        uberURL += "&dropoff[longitude]=\(venue.longitude)"
        
        uberURL += venue.address == nil ? "" :
            "&dropoff[formatted_address]=\(venue.address)"
        
        if let urlEncodedString = uberURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
            return NSURL(string: urlEncodedString)
        } else {
            return nil
        }
    }
}
