//
//  SimulateLogsViewController.swift
//  Manage Users
//
//  Created by BP-36-201-02 on 31/12/2025.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth

class SimulateLogsViewController: UIViewController {
    
    
    @IBOutlet weak var btnFoodItemListed: UIButton!
    @IBOutlet weak var btnDonationCreated: UIButton!
    @IBOutlet weak var btnDonationAccepted: UIButton!
    @IBOutlet weak var btnDonationComplete: UIButton!
    
    let adminId = Auth.auth().currentUser?.uid ?? "SYSTEM_ADMIN"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Simulate Logs"

        // Do any additional setup after loading the view.
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
                    AnalyticsParameterScreenName: "SimulateLogs",
                    AnalyticsParameterScreenClass: "SimulateLogsViewController"
                ])
    }
    
    @IBAction func foodItemListedTapped(_ sender: UIButton) {

        AuditLogger.log(
            action: "FOOD_ITEM_LISTED",
            targetUserId: adminId
        )

        showConfirmation("Food Item Listed log created")
    }
    
    @IBAction func donationCreatedTapped(_ sender: UIButton) {

        AuditLogger.log(
            action: "DONATION_CREATED",
            targetUserId: adminId
        )

        showConfirmation("Donation Created log created")
    }
    
    @IBAction func donationAcceptedTapped(_ sender: UIButton) {

        AuditLogger.log(
            action: "DONATION_ACCEPTED",
            targetUserId: adminId        )

        showConfirmation("Donation Accepted log created")
    }

    @IBAction func donationCompletedTapped(_ sender: UIButton) {

        AuditLogger.log(
            action: "DONATION_COMPLETED",
            targetUserId: adminId
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
