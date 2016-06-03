//
//  Favorites.swift
//  LetsGetDrinks
//
//  Created by soheiln on 6/2/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import Foundation
import CoreData

class Favorites: NSManagedObject {
    
    @NSManaged var venues: NSSet!
    
    // convenience initializer which in turn calls the designated initializer with entity and context parameters
    convenience init(context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entityForName("Favorites", inManagedObjectContext: context) {
            self.init(entity: ent, insertIntoManagedObjectContext: context)
            self.venues = NSSet()
        } else {
            fatalError("Unable to find Entity name: Favorites")
        }
    }
    
}

