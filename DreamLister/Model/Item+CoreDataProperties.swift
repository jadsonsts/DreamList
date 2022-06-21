//
//  Item+CoreDataProperties.swift
//  DreamLister
//
//  Created by Jadson on 21/06/22.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var name: String?
    @NSManaged public var details: String?
    @NSManaged public var price: Double
    @NSManaged public var created: Date?
    @NSManaged public var image: Image?
    @NSManaged public var itemType: ItemType?
    @NSManaged public var store: Store?

}

extension Item : Identifiable {

}
