//
//  ViewController.swift
//  DreamLister
//
//  Created by Jadson on 21/06/22.
//

import UIKit
import CoreData

class MainVC: UIViewController {
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        generateDummyData()
        attemptFetch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.editItem {
            if let destionation = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destionation.itemToEdit = item
                }
                
            }
        }
    }
    
}

//MARK: - IBActions

extension MainVC {
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        attemptFetch()
        tableView.reloadData()
    }
}

//MARK: - TableView setup
extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseID, for: indexPath) as? ItemCell else { return UITableViewCell() }
        
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func configureCell(_ cell: ItemCell, indexPath: IndexPath) {
        let item = controller.object(at: indexPath)
        cell.configCell(item)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects, objs.count > 0 {
            let item = objs[indexPath.row]
            performSegue(withIdentifier: Constants.Segues.editItem, sender: item)
        }
    }
    
}

extension MainVC: NSFetchedResultsControllerDelegate {
    func generateDummyData() {
        let item1 = Item(context: Constants.context)
        item1.name = "MacBook Pro"
        item1.price = 2299
        item1.details = "The new M2 chip makes the 13‑inch MacBook Pro more capable than ever. The same compact design supports up to 20 hours of battery life and an active cooling system to sustain enhanced performance.1 Featuring a brilliant Retina display, a FaceTime HD camera and studio‑quality mics, it’s our most portable pro laptop."
        
        let item2 = Item(context: Constants.context)
        item2.name = "Bose N700 HeadPhones"
        item2.price = 699
        item2.details = "Bose Noise Cancelling Headphones 700 deliver everything you expect - and things you never imagined possible. Get easy access to your choice of voice assistants, and control your content while your phone stays in your pocket."
        
        let item3 = Item(context: Constants.context)
        item3.name = "Tesla Model Y"
        item3.price = 125000
        item3.details = "Like every Tesla, Model Y is designed to be the safest vehicle in its class. The low centre of gravity, rigid body structure and large crumple zones provide unparalleled protection."
        
        Constants.appDelegate.saveContext() //save the data in the persisted container
    }
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "name", ascending: true)
        
        
        //to sort the data according to the segmentController selected
        switch segmentControl.selectedSegmentIndex {
        case 0:
            fetchRequest.sortDescriptors = [dateSort]
        case 1:
            fetchRequest.sortDescriptors = [priceSort]
        case 2:
            fetchRequest.sortDescriptors = [titleSort]
        default:
            break
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: Constants.context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        
        controller.delegate = self
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch let err {
            print(err)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell, indexPath: indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        @unknown default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}


