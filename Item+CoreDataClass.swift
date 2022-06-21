//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Jadson on 21/06/22.
//
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = Date()
    }
}
