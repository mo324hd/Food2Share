//
//  Home.swift
//  DonationTask
//
//  Created by wael on 06/01/2026.
//

import UIKit

class Home: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func navigateToRewards(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MyRewardsController") as! MyRewardsController

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func EmergencyClicked(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EmergenceyDonation") as! EmergenceyDonation
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func RecurringDonationsClicked(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RecurringDonations") as! RecurringDonations
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
