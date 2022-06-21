//
//  MaterialView.swift
//  DreamLister
//
//  Created by Jadson on 21/06/22.
//

import Foundation
import UIKit

enum Constants {
    static var materialKey: Bool = false
}

extension UIView {
    @IBInspectable var materialDesign: Bool {
        get {
            return Constants.materialKey
        }
        set {
            Constants.materialKey = newValue
            
            if Constants.materialKey {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.layer.shadowColor = CGColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 0.0)
            } else {
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
            }
        }
    }
}
