//
//  ItemCell.swift
//  DreamLister
//
//  Created by Jadson on 23/06/22.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    
    func configCell(_ item: Item) {
        //don't forget to add a property on the plist
        thumb.image = item.image?.image as? UIImage ?? UIImage(named: "imagePick")
        title.text = item.name
        price.text = "$\(item.price)"
        details.text = item.details
    }
}
