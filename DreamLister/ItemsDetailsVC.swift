//
//  ItemsDetailsVC.swift
//  DreamLister
//
//  Created by Apostolos Chalkias on 29/07/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import UIKit
import CoreData

class ItemsDetailsVC: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: IBOutlets
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    @IBOutlet weak var thumbImg: UIImageView!
    
    // MARK: Variables
    
    var stores = [Store]() //Instatiate an array of Store type entity
    var itemToEdit: Item? //Create an instance of the item to edit. It's optional because its not always used.
    var imagePicker: UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeBackButton()
        
        //Set the pickerView delegate and datasource
        storePicker.delegate = self
        storePicker.dataSource = self
        
        //Instatiate the image picker 
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        

        //Create some stores
        createStores()
        
        //Get the saved stores from core data
        getStores()
        
        //Check if we have passed an item to edit to determine whether or not to load item data
        if itemToEdit != nil {
            loadItemData()
        }
        
        
       
    }
    
    // MARK: PickerView Functions
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //Get the store name
        let store = stores[row]
        
        //Return it to the row
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //Return as many rows as the stores array
        return stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //How many colums
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Update when selected
    }
    
    
    
    // MARK: Custom Functions
    
    func changeBackButton(){
        //Change the back button name and style
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
    }

    func createStores() {
        
        //Create fetch request
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        var c: Int
        c = 0
        
        do {
            
            //Get the store from context and save them to stores array
            c = try context.fetch(fetchRequest).count
            
            //Notify data of the picker view
            self.storePicker.reloadAllComponents()
            
        } catch {
            
            //handle the error
        }
        
        //Dont add any store if the array already contains
        if c > 0 {
            return
        }
        
        //Create an instance of store entity and set the atributes
        let store = Store(context: context)
        store.name = "Best Buy"
        
        let store2 = Store(context: context)
        store2.name = "Tesla Dealership"
        
        let store3 = Store(context: context)
        store3.name = "Frys Electronics"
        
        let store4 = Store(context: context)
        store4.name = "Target"
       
        let store5 = Store(context: context)
        store5.name = "Amazon"
       
        let store6 = Store(context: context)
        store6.name = "K Mart"
        
        //Save stores
        ad.saveContext()
    }
    

    func getStores() {
    
        //Create fetch request
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
        
            //Get the store from context and save them to stores array
            self.stores = try context.fetch(fetchRequest)
            
            //Notify data of the picker view
            self.storePicker.reloadAllComponents()
        
        } catch {
        
            //handle the error
        }
    }
    
    func loadItemData(){
    
        //Check that we have passed an item to edit
        if let item = itemToEdit {
        
            //Set the fields
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            
            //Get the image
            thumbImg.image = item.toImage?.image as? UIImage
            
            //Set the store name picked
            if let store = item.toStore {
            
                //Loop through the store to find the one that is equal
                var index = 0
                repeat {
                
                    let s = stores[index]
                    
                    if s.name == store.name {
                    
                        //Select the pickerView row
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        
                        break
                    }
                    
                    index += 1
                    
                } while (index < stores.count)
                
            }
        }
    
    }
    
    
    
    // MARK: IBActions
    
    @IBAction func savedPressed(_ sender: UIButton) {
        
        //Create an item and save it or update it to context
        var item: Item!
        
        //Create an entity of the image
        let picture = Image(context: context)
        
        //Check if the item to edit is nil to dermine if to update or create the object
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            item = itemToEdit //Core data will take care of the rest to update the existing object
        }
        
      
        
        //Set the title
        if let title = titleField.text {
            item.title = title
        }
        
        //Set the price
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue //Convert string to double
        }
        
        //Set the details
        if let details = detailsField.text {
            item.details = details
        }
        
        //Set the image
        picture.image = thumbImg.image
        item.toImage = picture
        
        //Set the store. Get the value from the pickerView selected row in section 0
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        
        //Save the item
        ad.saveContext()
        
        
        //Go back to previous controller
        navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        //Check if the edit item is not nil
        if itemToEdit != nil {
            //Delete the item from context
            context.delete(itemToEdit!)
            //Save it
            ad.saveContext()
        }
        
        //Close the controller
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        
        //Open the image picker 
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //Extract the image from the returned dictionary
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
        
            //Set the image to imageView
            thumbImg.image = img
            
            
            
            
            
            //Close the imagePicker
            imagePicker.dismiss(animated: true, completion: nil)
            
        }
        
        
        
    }
    
    

 
}
