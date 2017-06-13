//
//  ShadowedImageView.swift
//  OpenFood
//
//  Created by MAFFINI Florian on 12/20/16.
//  Copyright © 2016 MAFFINI Florian. All rights reserved.
//

import UIKit

@IBDesignable
class ShadowedImageView: UIImageView {
    
    @IBInspectable var shadowColor: UIColor = UIColor.darkGray {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
            self.layer.shadowOpacity = 1
            self.layer.shadowOffset = CGSize.zero
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 10 {
        didSet {
            self.layer.shadowRadius = shadowRadius
            self.layer.shadowOpacity = 1
            self.layer.shadowOffset = CGSize.zero
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
