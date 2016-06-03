//
//  FavoritesContextDelegate.swift
//  LetsGetDrinks
//
//  Created by soheiln on 6/2/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import Foundation
import CoreData

class FavoritesFRCDelegate: NSObject, NSFetchedResultsControllerDelegate {
    
    // singleton design
    static var instance: FavoritesFRCDelegate!
    static func sharedInstance() -> FavoritesFRCDelegate {
        if instance == nil {
            instance = FavoritesFRCDelegate()
        }
        return instance
    }
    

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        // update favorites variable in CoreDataStack whenever content of frc changes
        let frc = CoreDataStack.sharedInstance().frc
        do {
            try frc.performFetch()
        } catch {
            print("Error while trying to perform a search: \n\(error)\n\(frc)")
        }
        CoreDataStack.sharedInstance().favorites = frc.fetchedObjects as! [Venue]
    }
    
}