//
//  RoundedNavigationBar.swift
//  Smart Donation Matching
//
//  Created by JAGmer J on 09/01/2026.
//

import UIKit

class RoundedNavigationBar: UINavigationBar {

    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
    }
        
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
