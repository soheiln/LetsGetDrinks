//
//  GoogleClient.swift
//  LetsGetDrinks
//
//  Created by soheiln on 5/26/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import Foundation
import UIKit

class GoogleClient {
    
    // static method that takes callerVC, latitude, and longitude and gets a set of venues near that coordinate
    static func getVenuesNearLocation(callerViewController vc: UIViewController, latitude: Double, longitude: Double, errorHandler: (() -> Void)?, completionHandler: (Venue -> Void) ) {
        
        // Configure HTTP request
        let url = NSURL(string: Constants.GoogleAPI.placeSearchMethodURL + "key=" + Constants.GoogleAPI.apiKey + "&location=" + String(latitude) + "," + String(longitude) + "&radius=" + Constants.GoogleAPI.radiusOfSearch + "&type=bar")!
        print(url) //todo: remove
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            // Handle error
            guard (error == nil) else {
                dispatch_async(dispatch_get_main_queue()) {
                    //TODO
                }
                return
            }
            
            // handle status code other than 2XX
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                dispatch_async(dispatch_get_main_queue()) {
                    //TODO
                }
                return
            }
            
            // handle empty data
            guard let _ = data else {
                dispatch_async(dispatch_get_main_queue()) {
                    //TODO
                }
                return
            }
            
            // Request succeeded, proceed to parse data
            extractVenuesFromJSON(data!, callerViewController: vc, errorHandler: errorHandler, completionHandler: completionHandler)
            
        }
        
        task.resume()
        
    }
    
    //TODO: update documentation
    // extracts a venue object from place search JSON response and calls the completion handler once a Venue object is available
    static func extractVenuesFromJSON(data: AnyObject, callerViewController vc: UIViewController, errorHandler: (() -> Void)?, completionHandler: (Venue -> Void) ) {
        
        let parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data as! NSData, options: .AllowFragments)
        } catch {
            print(error)
            dispatch_async(dispatch_get_main_queue()) {
                //TODO
            }
            return
        }

        let json = parsedResult as! [String: AnyObject]
        let results = json["results"] as! [[String: AnyObject]]
        for result in results {
            let name = result["name"] as! String
            let placeID = result["place_id"] as! String
            let venue = Venue.init(context: CoreDataStack.sharedInstance().scratchContext) // objects are first created in scratchContext
            venue.name = name
            venue.placeID = placeID
            getDetailsForVenue(venue, callerViewController: vc, errorHandler: errorHandler, completionHandler: completionHandler)
        }

        
    }
    
    
    //TODO: update documentation
    // extracts details for the venue by performing a Google place details API call and ca
    static func getDetailsForVenue(venue: Venue, callerViewController vc: UIViewController, errorHandler: (() -> Void)?, completionHandler: (Venue -> Void) ) {
        
        // Configure HTTP request
        let url = NSURL(string: Constants.GoogleAPI.placeDetailsMethodURL + "key=" + Constants.GoogleAPI.apiKey + "&placeid=" + venue.placeID)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            // Handle error
            guard (error == nil) else {
                dispatch_async(dispatch_get_main_queue()) {
                    //TODO
                }
                return
            }
            
            // handle status code other than 2XX
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                dispatch_async(dispatch_get_main_queue()) {
                    //TODO
                }
                return
            }
            
            // handle empty data
            guard let _ = data else {
                dispatch_async(dispatch_get_main_queue()) {
                    //TODO
                }
                return
            }
            
            // Request succeeded, proceed to parse data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            } catch {
                print(error)
                dispatch_async(dispatch_get_main_queue()) {
                    //TODO
                }
                return
            }
            
            let json = parsedResult as! [String: AnyObject]
            let result = json["result"] as! [String: AnyObject]
            let geometry = result["geometry"] as! [String: AnyObject]
            let location = geometry["location"] as! [String: AnyObject]
            venue.address = result["formatted_address"] as! String
            venue.phone = result["formatted_phone_number"] as! String
            venue.latitude = location["lat"] as! Double
            venue.longitude = location["lng"] as! Double
            let photos = result["photos"] as! [[String: AnyObject]]
            if photos.count > 0 {
                let photo = photos[0]
                let photo_reference = photo["photo_reference"] as! String
                getPhotoForVenue(venue, photo_reference: photo_reference, callerViewController: vc, errorHandler: errorHandler, completionHandler: completionHandler)
            } else {
                //TODO: check
                completionHandler(venue)
            }
            
        }
        task.resume()
    }
    
    
    //TODO: add documentation
    static func getPhotoForVenue(venue: Venue, photo_reference: String, callerViewController vc: UIViewController, errorHandler: (() -> Void)?, completionHandler: (Venue -> Void) ) {
        
        // Configure HTTP request
        var urlString = Constants.GoogleAPI.placePhotoMethodURL + "key=" + Constants.GoogleAPI.apiKey
        urlString = urlString + "&maxwidth=" + Constants.GoogleAPI.photoMaxWidth + "&photoreference=" + photo_reference
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            // Handle error
            guard (error == nil) else {
                dispatch_async(dispatch_get_main_queue()) {
                    //TODO
                }
                return
            }
            
            // handle status code other than 2XX
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                dispatch_async(dispatch_get_main_queue()) {
                    //TODO
                }
                return
            }
            
            // handle empty data
            guard let _ = data else {
                dispatch_async(dispatch_get_main_queue()) {
                    //TODO
                }
                return
            }
            
            // save photo data in venue object
            if let data = data {
                venue.photo = data
            }
            
            // call completion handler and hand over the loaded venue
            completionHandler(venue)
            
        }
        task.resume()
        
    }

}