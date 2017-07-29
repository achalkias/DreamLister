//
//  MainVC.swift
//  DreamLister
//
//  Created by Apostolos Chalkias on 29/07/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController,UITableViewDelegate,UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    
    // MARK: Variables
    
    //Init a fetch controller and fetch the Item model.
    var controller: NSFetchedResultsController<Item>!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Set tableView delgate and datasource
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //Add some test data
        //generateTestData()
        
       
        //Fetch the data
        attemptFetch()
    
    }
    
    // MARK: TableView Functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Get the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        //Call configure cell function
        configureCell(cell: cell, indexPatch: indexPath as NSIndexPath)
        
        //Return the cell
        return cell
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Grab the sections out of the controller
        if let sections = controller.sections {
        
            //Grab the section from sections
            let sectionInfo = sections[section]
            
            //Get the number of objects
            return sectionInfo.numberOfObjects
        }
        return 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        //Grab the sections out of the controller
        if let sections = controller.sections {
            //Return the sections count
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Return a specific height for tableView row
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Check if the objects are not 0
        if let obj = controller.fetchedObjects , obj.count > 0 {
         
            //Get the item
            let item = obj[indexPath.row]
            
            //Perform the segue
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
            
        }
    }
    
    
    // MARK: Custom Functions
    
    func configureCell(cell: ItemCell, indexPatch: NSIndexPath) {
    
        //Updated cell
        
        //Create an item
        let item = controller.object(at: indexPatch as IndexPath)
        
        //Call primary configure cell function and pass the created item
        cell.configureCell(item: item)
    
    }
    
    
    
    func attemptFetch() {
        
        //Create a fetch request
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        //Create variables to sort the data.
        let dateSort = NSSortDescriptor(key: "created", ascending: false) //Sorting based on the timestamp
        let priceSort = NSSortDescriptor(key: "price", ascending: true) //Sorting based on price
        let titleSort = NSSortDescriptor(key: "title", ascending: true) //Sorting based on title
        
        //Sort the request
        if segment.selectedSegmentIndex == 0{
            fetchRequest.sortDescriptors = [dateSort]
        } else if segment.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [priceSort]
        } else if segment.selectedSegmentIndex == 2 {
            fetchRequest.sortDescriptors = [titleSort]
        }
        
        
        //Instantiate fetchController
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        //Set the controller
        self.controller = controller
        
        //Set the controller delegate
        controller.delegate = self
        
        //Do the fetch
        do {
        
            //Perform the fetch
            try controller.performFetch()
        
            
        } catch {
        
            let error = error as NSError
            print("\(error)")
            
        }
    }
    

    
    func generateTestData() {
    
        
        //Create an item and add data
        let item = Item(context: context)
        item.title = "Macbook Pro"
        item.price = 2.688
        item.details = "I cant wait to buy a new one macbook. I hope i will get it as soon as posible."
        
        //Create an item and add data
        let item2 = Item(context: context)
        item2.title = "Bose Headphones"
        item2.price = 300
        item2.details = "Man its so nice to be able to block anyone with the noise cancceling tech."
        
        //Create an item and add data
        let item3 = Item(context: context)
        item3.title = "Tesla Model S"
        item3.price = 110000
        item3.details = "Oh man this is a beatyfull car and one day i will own it."
        
        //Save data to database
        ad.saveContext()
    
    }
    
    
    // MARK: NSFetchResults Functions
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //Update tableView data
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //Stop update the tableView
        tableView.endUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        //This listening for when a change is made. Insert, delete, move and update
        
        //Switch cases for all modification types
        switch (type){
        
        case.insert:
            
            //Insert an item to tableView
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            
            //Delete an item from tableView
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
            
        case.update:
            
            //Update an item from tableView
            if let indexPath = indexPath {
                //Get the cell of the tableView
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                
                //Call configure cell to update the cell
                configureCell(cell: cell, indexPatch: indexPath as NSIndexPath)
            }
            break
        case.move:
            
            //Move an item in tableView
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade) //Delete item
            }
            
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade) //Add item
            
            }
            break
        }
        
        
    }
    
    
    
    // MARK: SEGUES
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Check the identifier
        if segue.identifier == "ItemDetailsVC" {
            //Get the destination view controller
            if let destination = segue.destination as? ItemsDetailsVC {
             
                //Get the item
                if let item = sender as? Item {
                    //Set the item to edit in ItemDetailsVC from the selected item
                    destination.itemToEdit = item
                }
            }
        }
        
    }
    
    // MARK: IBActions
    
    
    @IBAction func segmentChanged(_ sender: Any) {
        
        attemptFetch()
        tableView.reloadData()
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

