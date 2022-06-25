//
//  Uitils.swift
//  DreamLister
//
//  Created by Jadson on 23/06/22.
//

import Foundation
import UIKit

enum Constants {
    static var materialKey: Bool = false
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let context = appDelegate.persistentContainer.viewContext
    static let cellReuseID = "ItemCell"
    
    enum Segues {
        static let addNew = "SegueAddNewItem"
        static let editItem = "SegueEditItem"
    }
    
}
