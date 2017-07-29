//
//  MaterialView.swift
//  DreamLister
//
//  Created by Apostolos Chalkias on 29/07/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import UIKit

//Set a the default selection to false. So it want be selected by default.
private var materialKey = false

//Any thing that inherits from UIView will have this style
extension  UIView {
    
    
    //Select later to story board if we want to use it or not.
    @IBInspectable var materialDesign: Bool {
        
        
        get {
            return materialKey
        }
        set {
            
            //Select whether or not the material design will be added to the view
            materialKey = newValue
            
            //If it is selected
            if materialKey {
                
                //Make mask to bounds false
                self.layer.masksToBounds = false
                
                //Give some nice rounding
                self.layer.cornerRadius = 3.0
                
                //Give some shadow
                self.layer.shadowOpacity = 0.8
                
                //Give radius to shadow
                self.layer.shadowRadius = 3.0
                
                //Give shadow offset width and height
                self.layer.shadowOffset = CGSize(width: 0.0, height: 0.2)
                
                //Set the shadow color
                self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
                
            } else {
                
                //Set them back to default
                
                
                self.layer.cornerRadius = 0
                
                
                self.layer.shadowOpacity = 0
                
                
                self.layer.shadowRadius = 0
                
                
                self.layer.shadowColor = nil
                
            }
        }
        
    }
    
    
}
