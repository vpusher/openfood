//
//  BlurredImageView.swift
//  OpenFood
//
//  Created by MAFFINI Florian on 12/19/16.
//  Copyright © 2016 MAFFINI Florian. All rights reserved.
//

import UIKit

@IBDesignable
class BlurredImageView: UIImageView {
    
    private var blur: UIVisualEffectView? = nil

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    /*override func draw(_ rect: CGRect) {
        // Drawing code
    }*/
    
    override func didMoveToSuperview() {
        updateBlurFrame()
    }
    
    func updateBlurFrame() {
        if let blur = blur {
            blur.frame = bounds
        } else {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            blur = UIVisualEffectView(effect: blurEffect)
            blur?.frame = bounds
            addSubview(blur!)
        }
    }

}
