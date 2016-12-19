//
//  Food.swift
//  OpenFood
//
//  Created by MAFFINI Florian on 11/27/16.
//  Copyright © 2016 MAFFINI Florian. All rights reserved.
//

import Foundation
import UIKit

class Food {
    
    var name: String?
    var brand: String?
    var thumbnail: String?
    var nutritionGrade: String?
    
    init () {
    }
    
    init (name: String?, brand: String?, thumbnail: String?, nutritionGrade: String?) {
        self.name = name;
        self.thumbnail = thumbnail;
        self.nutritionGrade = nutritionGrade;
        self.brand = brand;
    }
    
    static func fromDictionnary(_ product: Dictionary<String, AnyObject>) -> Food {
        
        let food = Food()
        
        food.name = product["product_name"] as? String
        food.brand = product["brands"] as? String
        food.thumbnail = product["image_url"] as? String
        
        let grades = product["nutrition_grades_tags"] as? [String]
        food.nutritionGrade = grades?[0]
        
        return food
        
    }
    
}
