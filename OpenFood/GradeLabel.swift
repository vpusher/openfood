//
//  GradeLabel.swift
//  OpenFood
//
//  Created by MAFFINI Florian on 12/2/16.
//  Copyright © 2016 MAFFINI Florian. All rights reserved.
//

import UIKit

@IBDesignable
class GradeLabel: UILabel {
    
    let grades: [String: UIColor] = [
        "a": UIColor(red: 0.012, green: 0.506, blue: 0.255, alpha: 1.0),
        "b": UIColor(red: 0.522, green: 0.733, blue: 0.184, alpha: 1.0),
        "c": UIColor(red: 0.996, green: 0.796, blue: 0.008, alpha: 1.0),
        "d": UIColor(red: 0.933, green: 0.506, blue: 0.0, alpha: 1.0),
        "e": UIColor(red: 0.902, green: 0.243, blue: 0.066, alpha: 1.0),
    ]
    
    @IBInspectable var grade: String? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        //self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5
        
        if grade != nil && grades[grade!] != nil  {
            let color = grades[grade!]
            self.text = grade!.uppercased()
            //self.layer.borderColor = color?.cgColor
            self.layer.backgroundColor = color?.cgColor
            self.textColor = UIColor.white
        } else {
            self.isHidden = true
        }
        super.draw(rect)
    }
 

}
