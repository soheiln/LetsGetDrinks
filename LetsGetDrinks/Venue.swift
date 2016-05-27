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
    
    convenience init(context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entityForName("Venue", inManagedObjectContext: context) {
            self.init(entity: ent, insertIntoManagedObjectContext: context)
        } else {
            fatalError("Could not find Entity for name: Venue")
        }
    }
}
