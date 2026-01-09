//
//  CollectionHeaderUICollectionReusableView.swift
//  Smart Donation Matching
//
//  Created by 202300470 on 06/01/2026.
//

import UIKit

class CollectionHeaderUICollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var headerLabel: UILabel!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        backgroundColor = UIColor.systemPurple.withAlphaComponent(0.1)
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        backgroundColor = UIColor.systemPurple.withAlphaComponent(0.1)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
