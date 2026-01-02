//
//  CustomTableViewCell.swift
//  Admin Manage Users
//
//  Created by BP-19-114-19 on 09/12/2025.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var viewButton: UIButton!
    
    var onViewTapped: (() -> Void)?

       @IBAction func viewButtonTapped(_ sender: UIButton) {
           print("✅ View button tapped")
           onViewTapped?()
       }
    
    
    override func awakeFromNib() {
           super.awakeFromNib()
           selectionStyle = .none
           contentView.isUserInteractionEnabled = true
       }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
