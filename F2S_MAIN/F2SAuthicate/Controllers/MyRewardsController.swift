//
//  MyRewardsController.swift
//  F2SAuthicate
//
//  Created by abdulaziz on 19/12/2025.
//

import UIKit

class MyRewardsController: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
    }

    
    @IBAction func close(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func firstDonation(_ sender: Any) {
        
        ShowSheet(image: UIImage(named: "Campaign 3")!, title: "Dessert Reward", points: 400, describtion: "Use your points to claim a  delicious dessert or drink voucher from our local partners")
        
    }
    
    @IBAction func fiendlyGift(_ sender: Any) {
        
        ShowSheet(image: UIImage(named: "Campaign4")!, title: "Reusable Tote bag", points: 200, describtion: "Redeem an exclusive, sustainable tote bag made for our active donors")
        
    }
    
    @IBAction func MonthlyEntry(_ sender: Any) {
        
        ShowSheet(image: UIImage(named: "coffe")!, title: "Win a free meal or coffee", points: 200, describtion: "Use your points to join the monthly raffle and get a chance to win special rewards")
        
    }
    
    @IBAction func surpriseBox(_ sender: Any) {
        
        ShowSheet(image: UIImage(named: "surpeise")!, title: "Mystery Reward", points: 300, describtion: "Redeem points for a surprise gift, could be a sweet treat, snack or mini goodie")
        
    }
    
    @IBAction func restaurentClicked(_ sender: Any) {
        
        ShowSheet(image: UIImage(named: "Campaign 2")!, title: "Dine & Save", points: 700, describtion: "Redeem points for a 15% discount at selected local restaurants", isRest: true)
        
    }
    
    
    func ShowSheet(image:UIImage,title:String,points:Int,describtion:String, isRest:Bool = false)  {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultController = storyboard.instantiateViewController(withIdentifier: "BottomSheetAlerts") as? BottomSheetAlerts

        resultController?.image = image
        resultController?.donationTitle = title
        resultController?.points = points
        resultController?.describtion = describtion
        resultController?.isRestaurent = isRest
        
        resultController?.modalPresentationStyle = .formSheet
        self.present(resultController ?? ViewController() , animated: true, completion: nil)
        
    }
    
    
    @IBAction func openVouchers(_ sender: Any) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultController = storyboard.instantiateViewController(withIdentifier: "VouchersController") as? VouchersController

        resultController?.modalPresentationStyle = .fullScreen
        self.present(resultController ?? ViewController() , animated: true, completion: nil)
        
    }

}
