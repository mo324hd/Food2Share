//
//  DonationCell.swift
//  DonationProject
//
//  Created by wael on 25/12/2025.
//

import UIKit

class DonationCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var onTimelineTapped: (() -> Void)?
    var onDistanceClicked: (() -> Void)?
    var scanClicked: (() -> Void)?
    
      @IBAction func viewtimeLine(_ sender: Any) {
          onTimelineTapped?()
      }
    
    @IBAction func distnceClicked(_ sender: Any) {
        onDistanceClicked?()
    }
    
    @IBAction func scanClickedButt(_ sender: Any) {
        scanClicked?()
    }
    
}
