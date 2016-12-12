//
//  ViewController.swift
//  OpenFood
//
//  Created by MAFFINI Florian on 11/27/16.
//  Copyright © 2016 MAFFINI Florian. All rights reserved.
//

import UIKit

class FoodDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    private let default_thumbnail = UIImage(named: "default_food")!
    private var blur: UIVisualEffectView? = nil
    
    var food: Food!
    
    func updateUI() {
        self.nameLabel.text = food?.name
        
        if self.food?.thumbnail != nil {
            DataService.ImageFromURL(food.thumbnail!, callback: { (imageData) in
                DispatchQueue.main.async(){
                    let im =  UIImage(data: imageData!)
                    self.imageView.image = im
                    self.backgroundImage.image = im
                }
            })
        } else {
            DispatchQueue.main.async(){
                self.imageView.image = self.default_thumbnail
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = self.food.name


        
        updateUI()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let blur = blur {
            blur.frame = backgroundImage.bounds
        } else {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            blur = UIVisualEffectView(effect: blurEffect)
            blur?.frame = backgroundImage.bounds
            backgroundImage.addSubview(blur!)
        }
    }

}

