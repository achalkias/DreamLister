//
//  ItemCell.swift
//  DreamLister
//
//  Created by Apostolos Chalkias on 29/07/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    
    
    // MARK: Primary Configure Cell Function
    func configureCell(item: Item) {
    
        //Update the title
        title.text = item.title
        
        //Update the price
        price.text = "$\(item.price)"
        details.text = item.details
        
        //Set the image
        thumb.image = item.toImage?.image as? UIImage
            
    }

}
