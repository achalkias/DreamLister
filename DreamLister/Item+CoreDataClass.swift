//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Apostolos Chalkias on 29/07/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        //Any time an item is insterted in NSManagedObject this function will be called
        
        //Call super class
        super.awakeFromInsert()
        
        //When an item is being created. Assing the current date timestamp to atribute created
        self.created = NSDate()
        
        
    }

}
