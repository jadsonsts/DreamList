//
//  ItemsDetailsVC.swift
//  DreamLister
//
//  Created by Jadson on 25/06/22.
//

import UIKit
import CoreData


class ItemDetailsVC: UIViewController {
    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    @IBOutlet weak var storePicker: UIPickerView!
    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storePicker.dataSource = self
        storePicker.delegate = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        //generateStores()
        getStores()
        
        if itemToEdit != nil {
            loadExistingData()
        }
    }
    
}

//MARK: - IBActions
extension ItemDetailsVC {
    
    @IBAction func savePressed(_ sender: UIButton) {
        var item: Item!
        let photo = Image(context: Constants.context)
        photo.image = thumb.image
        
        if itemToEdit != nil {
            item = itemToEdit
        } else {
            item = Item(context: Constants.context) //instantiate the object
        }
        guard let title = titleField.text, !title.isEmpty,
              let price = priceField.text, !title.isEmpty else { return } //could use alert controller to ask for input valid data
        
        item.name = title
        item.price = Double(price) ?? 0.0
        
        if let details = detailsField.text {
            item.details = details
        }
        item.image = photo
        item.store = stores[storePicker.selectedRow(inComponent: 0)]
        
        Constants.appDelegate.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        if itemToEdit != nil {
            Constants.context.delete(itemToEdit!)
            Constants.appDelegate.saveContext()
            navigationController?.popViewController(animated: true)
        } else {
            titleField.text = ""
            priceField.text = ""
            detailsField.text = ""
            thumb.image = UIImage(named: "imagePick")
            storePicker.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
}

//MARK: - UIPicker Setup
extension ItemDetailsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    //returning 1 coz is only store, otherwise can return more, like date(DMY)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    
}

//MARK: - Retrieve Stores
extension ItemDetailsVC {
    
    func generateStores() {
        let store = Store(context: Constants.context)
        store.name = "Noel Leeming"
        
        let store1 = Store(context: Constants.context)
        store1.name = "Apple"
        
        let store2 = Store(context: Constants.context)
        store2.name = "JB Hi-Fi"
        
        let store3 = Store(context: Constants.context)
        store3.name = "Harvey Norman"
        
        let store4 = Store(context: Constants.context)
        store4.name = "Tesla Motors"
        
        let store5 = Store(context: Constants.context)
        store5.name = "PB Tech"
        
        let store6 = Store(context: Constants.context)
        store6.name = "Amazon"
    }
    
    func getStores() {
        //create fetchRequest
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        do {
            self.stores = try Constants.context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch let err { //it can be hadled in another way, if I get the data from a api, I could show to the user
            print(err)
        }
    }
    
    func loadExistingData() {
        if let item = itemToEdit {
            titleField.text = item.name
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumb.image = item.image?.image as? UIImage
            
            //looping through the stores and set the store picker at the appropriate row
            if let store = item.store {
                var index = 0
                repeat {
                    let storeName = stores[index]
                    if storeName.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: true) //check what happens when select true
                        break
                    }
                    index += 1
                } while (index < stores.count)
            }
        }
    }
    
}

//MARK: - UIImagePicker Delegate
extension ItemDetailsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            thumb.image = image
        }
        picker.dismiss(animated: true)
    }
}
