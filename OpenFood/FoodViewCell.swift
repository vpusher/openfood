//
//  FoodTableView.swift
//  OpenFood
//
//  Created by MAFFINI Florian on 11/27/16.
//  Copyright © 2016 MAFFINI Florian. All rights reserved.
//

import UIKit

class FoodViewCell : UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gradeLabel: GradeLabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    
    private let default_thumbnail = UIImage(named: "default_food")!
    
    var food: Food! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        self.nameLabel.text = food.name
        self.brandLabel.text = food.brand
        self.gradeLabel.grade = food.nutritionGrade
        
        if food.thumbnail != nil {
            DataService.ImageFromURL(self.food.thumbnail!, callback: { (imageData) in
                DispatchQueue.main.async(){
                    self.thumbnailView.image = UIImage(data: imageData!)
                }
            })
        } else {
            DispatchQueue.main.async(){
                self.thumbnailView.image = self.default_thumbnail
            }
        }
    }
}
