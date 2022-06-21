//
//  Image+CoreDataProperties.swift
//  DreamLister
//
//  Created by Jadson on 21/06/22.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var image: NSObject?
    @NSManaged public var item: Item?
    @NSManaged public var store: Store?

}

extension Image : Identifiable {

}
