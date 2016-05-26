//
//  YelpClient.swift
//  LetsGetDrinks
//
//  Created by soheiln on 5/26/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import Foundation
import UIKit

class YelpClient {
    
    // static method that takes callerVC, latitude, and longitude and gets a set of photos near that coordinate
    static func getVenuesNearLocation(callerViewController vc: UIViewController, latitude: Double, longitude: Double, page_number: Int?, errorHandler: ((NSData?, NSURLResponse?, NSError?) -> Void)?, completionHandler: (NSData -> Void) ) {
        
        // Configure HTTP request
        let url = NSURL(string: Constants.YelpAPI.methodURL + String(latitude) + "," + String(longitude))!
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
            
            var data = NSMutableData(data: data!)
            
            // remove the jsonp method from json response
            data =  NSMutableData(data: data.subdataWithRange(NSMakeRange(14, data.length - 15)))
            
            // Request succeeded, proceed to parse data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                print(error)
                dispatch_async(dispatch_get_main_queue()) {
                    //TODO
                }
                return
            }
            
            //TODO
            
        }
        
        task.resume()
        
    }
    
}