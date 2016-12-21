//
//  ViewController.swift
//  OpenFood
//
//  Created by MAFFINI Florian on 11/27/16.
//  Copyright © 2016 MAFFINI Florian. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var thumbnailImage: ShadowedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backgroundImage: BlurredImageView!
    
    @IBOutlet weak var aGradeLabel: GradeLabel!
    @IBOutlet weak var bGradeLabel: GradeLabel!
    @IBOutlet weak var cGradeLabel: GradeLabel!
    @IBOutlet weak var dGradeLabel: GradeLabel!
    @IBOutlet weak var eGradeLabel: GradeLabel!

    private let defaultThumbnail = UIImage(named: "default_food")!
    
    var food: Food!
    
    func updateUI() {
        self.nameLabel.text = food?.name

        for gradeLabel in [aGradeLabel, bGradeLabel, cGradeLabel, dGradeLabel, eGradeLabel] where (gradeLabel?.grade == food?.nutritionGrade) {

            for heightConstraint in (gradeLabel?.constraints)! where (heightConstraint.identifier == "height") {
                heightConstraint.constant = 50
                break
            }

            for widthConstraint in (gradeLabel?.constraints)! where (widthConstraint.identifier == "width") {
                widthConstraint.constant = 50
                break
            }

            gradeLabel?.borderRadius = true
            gradeLabel?.layer.zPosition = 1
        }
        
        if self.food?.thumbnail != nil {
            DataService.ImageFromURL(food.thumbnail!, callback: { (imageData) in
                DispatchQueue.main.async(){
                    let im =  UIImage(data: imageData!)
                    self.thumbnailImage.image = im
                    self.backgroundImage.image = im
                }
            })
        } else {
            DispatchQueue.main.async(){
                self.thumbnailImage.image = self.defaultThumbnail
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImage.updateBlurFrame()
    }

}

