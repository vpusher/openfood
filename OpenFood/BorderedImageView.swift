//
//  BorderedImageView.swift
//  OpenFood
//
//  Created by MAFFINI Florian on 12/19/16.
//  Copyright © 2016 MAFFINI Florian. All rights reserved.
//

import UIKit

@IBDesignable
class BorderedImageView: UIImageView {
    
    @IBInspectable var borderWidth: CGFloat = 5 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
