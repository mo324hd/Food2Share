//
//  RoundedTopView.swift
//  Smart Donation Matching
//
//  Created by 202300470 on 04/01/2026.
//

import UIKit

class RoundedTopView: UIView {
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 30
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
