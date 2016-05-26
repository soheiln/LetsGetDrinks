//
//  UIUtilities.swift
//  LetsGetDrinks
//
//  Created by soheiln on 5/25/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class UIUtilities {
    
    // shows alert with message and "OK" action
    static func showAlret(callerViewController vc: UIViewController, message: String, completionHandler: (()->Void)) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(alertAction)
        vc.presentViewController(alert, animated: true, completion: nil)
        // call completion handler (e.g. to stop activity indicator)
        completionHandler()
    }
    
    // modally presents an overlay 'location details' view
    static func showLocationDetailsOverlay(callerViewController vc: UIViewController, location: Location, completionHandler: (()->Void)) {
        
    }

}
