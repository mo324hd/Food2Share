//
//  SimulateLogsViewController.swift
//  Manage Users
//
//  Created by BP-36-201-02 on 31/12/2025.
//

import UIKit

class SimulateLogsViewController: UIViewController {
    
    
    @IBOutlet weak var btnFoodItemListed: UIButton!
    @IBOutlet weak var btnDonationCreated: UIButton!
    @IBOutlet weak var btnDonationAccepted: UIButton!
    @IBOutlet weak var btnDonationComplete: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Simulate Logs"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func foodItemListedTapped(_ sender: UIButton) {

        AuditLogger.log(
            action: "FOOD_ITEM_LISTED",
            message: "Food item listed by donor"
        )

        showConfirmation("Food Item Listed log created")
    }
    
    @IBAction func donationCreatedTapped(_ sender: UIButton) {

        AuditLogger.log(
            action: "DONATION_CREATED",
            message: "Donation created from listed food item"
        )

        showConfirmation("Donation Created log created")
    }
    
    @IBAction func donationAcceptedTapped(_ sender: UIButton) {

        AuditLogger.log(
            action: "DONATION_ACCEPTED",
            message: "Donation accepted by collector"
        )

        showConfirmation("Donation Accepted log created")
    }

    @IBAction func donationCompletedTapped(_ sender: UIButton) {

        AuditLogger.log(
            action: "DONATION_COMPLETED",
            message: "Donation marked as completed"
        )

        showConfirmation("Donation Completed log created")
    }

    
    private func showConfirmation(_ message: String) {
        let alert = UIAlertController(
            title: "Simulated",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
