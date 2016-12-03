//
//  Food.swift
//  openfoodfacts
//
//  Created by MAFFINI Florian on 11/27/16.
//  Copyright © 2016 MAFFINI Florian. All rights reserved.
//

import Foundation
import UIKit

class Food {
    
    var name: String
    var brand: String?
    var thumbnail: String?
    var nutritionGrade: String?
    
    init (name: String, brand: String?, thumbnail: String?, nutritionGrade: String?) {
        self.name = name;
        self.thumbnail = thumbnail;
        self.nutritionGrade = nutritionGrade;
        self.brand = brand;
    }
    
}
