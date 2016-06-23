//
//  Venue
//  LetsGetDrinks
//
//  Created by soheiln on 5/25/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import Foundation
import CoreData

class Venue: NSManagedObject {
    @NSManaged var placeID: String!
    @NSManaged var name: String!
    @NSManaged var phone: String!
    @NSManaged var address: String!
    @NSManaged var photo: NSData!
    @NSManaged var latitude: NSNumber!
    @NSManaged var longitude: NSNumber!
    
    convenience init(context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entityForName("Venue", inManagedObjectContext: context) {
            self.init(entity: ent, insertIntoManagedObjectContext: context)
        } else {
            fatalError("Could not find Entity for name: Venue")
        }
    }
    
    convenience init(venue: Venue, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entityForName("Venue", inManagedObjectContext: context) {
            self.init(entity: ent, insertIntoManagedObjectContext: context)
            self.placeID = venue.placeID
            self.name = venue.name
            self.phone = venue.phone
            self.address = venue.address
            self.photo = venue.photo
            self.latitude = venue.latitude
            self.longitude = venue.longitude
        } else {
            fatalError("Could not find Entity for name: Venue")
        }
    }

    
    // decides whether a venue is favorite if i) its managed object context is main context
    // or ii) if there's an object in the favorites whose placeID is the same
    func isFavorite() -> Bool {
        let favoritesContext = CoreDataStack.sharedInstance().managedObjectContext
        if self.managedObjectContext == favoritesContext {
            return true
        }
        let favorites = CoreDataStack.sharedInstance().favorites
        for item in favorites {
            if item.placeID == self.placeID {
                return true
            }
        }
        return false
    }
    
    
    // a venue is favorited by adding it to the main context and removing from scratch context
    func addToFavorites() {
        if isFavorite() {
            // already favorite, no action needed
            return
        } else {
            // create a new similar venue object in the main context
            let favoritesContext = CoreDataStack.sharedInstance().managedObjectContext
            _ = Venue(venue: self, context: favoritesContext)
            CoreDataStack.sharedInstance().saveContext()

        }
        CoreDataStack.sharedInstance().loadData()
    }
    
    
    // a venue is favorited by being removed from the main context
    func removeFromFavorites () {
        if !isFavorite() {
            return
        }
        let favoritesContext = CoreDataStack.sharedInstance().managedObjectContext
        let favorites = CoreDataStack.sharedInstance().favorites
        var index = 0
        for item in favorites {
            if item.placeID == self.placeID {
                favoritesContext.deleteObject(item)
                CoreDataStack.sharedInstance().saveContext()
                CoreDataStack.sharedInstance().favorites.removeAtIndex(index)
            }
            index += 1
        }

    }
}
