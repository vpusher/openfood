//
//  DetailViewController.swift
//  OpenFood
//
//  Created by MAFFINI Florian on 12/21/16.
//  Copyright © 2016 MAFFINI Florian. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var food: Food! {
        didSet {
            self.infoViewController?.food = food
            //self.ingredientViewController.food = food
            //self.nutritionViewController.food = food
        }
    }
    var navigationHairline: UIImageView!

    @IBOutlet weak var segmentBar: UIToolbar!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var nutritionContainer: UIView!
    @IBOutlet weak var ingredientContainer: UIView!
    @IBOutlet weak var infoContainer: UIView!
    
    var infoViewController: InfoViewController?
    var ingredientViewController: UIViewController!
    var nutritionViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = self.food.name
        
        for rootsubview in (self.navigationController?.navigationBar.subviews)! {
            for subview in rootsubview.subviews where subview is UIImageView
                && (subview as! UIImageView).image == self.navigationController?.navigationBar.shadowImage {
                    self.navigationHairline = subview as! UIImageView
            }
        }

        // Do any additional setup after loading the view.
    }
    @IBAction func segmentSelected(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
            case 0:
                infoContainer.isHidden = false
                nutritionContainer.isHidden = true
                ingredientContainer.isHidden = true
            case 1:
                infoContainer.isHidden = true
                nutritionContainer.isHidden = true
                ingredientContainer.isHidden = false
            case 2:
                infoContainer.isHidden = true
                nutritionContainer.isHidden = false
                ingredientContainer.isHidden = true
            default: break;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        moveHairline(true)
        self.navigationHairline.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        moveHairline(false)
        self.navigationHairline.isHidden = true
    }
    
    
    func moveHairline(_ appearing: Bool) {
        // move the hairline below the segmentbar
        var hairlineFrame = self.navigationHairline.frame;
        if (appearing) {
            hairlineFrame.origin.y += self.segmentBar.bounds.size.height;
        } else {
            hairlineFrame.origin.y -= self.segmentBar.bounds.size.height;
        }
        self.navigationHairline.frame = hairlineFrame
    }
    


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goembed") {
            if (segue.destination is InfoViewController) {
                self.infoViewController = segue.destination as? InfoViewController
                self.infoViewController?.food = self.food
            }
        }
    }

}
