//
//  BottomSheetAlerts.swift
//  F2SAuthicate
//
//  Created by abdulaziz on 24/12/2025.
//

import UIKit

class BottomSheetAlerts: UIViewController {

    @IBOutlet weak var reedemView: RoundedButton!
    @IBOutlet weak var confirmView: RoundedButton!
    
    @IBOutlet weak var reddemOt: RoundedButton!
    @IBOutlet weak var restaurentStack: UIStackView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var describtionLbl: UILabel!
    
    var points: Int?
    var donationTitle:String?
    var describtion:String?
    var image:UIImage?
    var isRestaurent:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUi()
    }
    
    
    func setUi(){
        
        coverImage.image = image ?? UIImage()
        pointsLbl.text = "\(points ?? 0) points"
        titleLbl.text = donationTitle ?? ""
        describtionLbl.text = describtion ?? ""
        
        
        restaurentStack.isHidden = !isRestaurent
        reddemOt.isEnabled = !isRestaurent
        
    }
    
    
    @IBAction func close(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
    
    @IBAction func reddemClicked(_ sender: Any) {
          
       
        
    }
    
    
    
}
