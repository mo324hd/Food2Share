//
//  CollectorCollectionViewCell.swift
//  DonateToCollector
//
//  Created by 202300470 on 16/12/2025.
//

import UIKit

protocol DonateToCollectorCollectionViewCellDelegate: AnyObject
{
    func didTapDetails(for id: Int)
}

class DonateToCollectorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgCollectorLogo: UIImageView!
    @IBOutlet weak var lblVerifiedCollector: UILabel!
    @IBOutlet weak var lblCollectorName: UILabel!
    @IBOutlet weak var btnShowDetails: UIButton!
    
    var collector: BaseCollector?
    weak var delegate: DonateToCollectorCollectionViewCellDelegate?
    
    @IBAction func buttonTapped(_ sender: UIButton)
    {
        delegate?.didTapDetails(for: collector!.internalID)
    }
    
    func populateCell(image: UIImage, verified: Bool, name: String)
    {
        imgCollectorLogo.image = image;
        lblCollectorName.text = name;
        
        if(verified)
        {
            lblVerifiedCollector.isHidden = false;
            let iconAttachment = NSTextAttachment();
            iconAttachment.image = UIImage(systemName: "checkmark.seal.fill")!.withTintColor(.systemPurple)
            iconAttachment.bounds = CGRect(x: 0, y: -4, width: 15, height: 15)
            let attributedText = NSMutableAttributedString(string: "Verified Collector ")
            attributedText.append(NSAttributedString(attachment: iconAttachment))
            
            lblVerifiedCollector.attributedText = attributedText;
        }
        else
        {
            lblVerifiedCollector.isHidden = true;
        }
    }
}
