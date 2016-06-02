//
//  PortraitTabBarController.swift
//  LetsGetDrinks
//
//  Created by soheiln on 6/2/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import Foundation
import UIKit

class PortraitTabBarController: UITabBarController {
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }

}