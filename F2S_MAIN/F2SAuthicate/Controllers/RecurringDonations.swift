//
//  RecurringDonations.swift
//  DonationTask
//
//  Created by wael on 06/01/2026.
//

import UIKit

class RecurringDonations: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
    }
    
    
    @IBAction private func close(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func CreateRecurringSchedule(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CreateRecurringDonations") as! CreateRecurringDonations
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    

}
