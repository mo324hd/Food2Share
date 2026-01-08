//
//  AdminPanelViewController.swift
//  Manage Users
//
//  Created by BP-36-201-10 on 28/12/2025.
//

import UIKit
import FirebaseAnalytics

class AdminPanelViewController: UIViewController {
    
    @IBOutlet weak var manageUsersButton: UIButton!
    @IBOutlet var viewLogsButton: UIView!

    
    @IBOutlet weak var simulateLogsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Admin Panel"
        view.backgroundColor = .systemBackground
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
                    AnalyticsParameterScreenName: "AdminPanel",
                    AnalyticsParameterScreenClass: "AdminPanelViewController"
                ])
    }

    @IBAction func manageUsersTapped(_ sender: UIButton) {
        print("Nav controller:", navigationController as Any)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: "UserTableViewController"
        )
        Analytics.logEvent("manage_users_tapped", parameters: [
                "action_type": "button_click"
            ])
        
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func viewLogsTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: "LogsTableViewController"
        )
        
        Analytics.logEvent("view_logs_tapped", parameters: [
            "action_type": "button_click"
        ])
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func simulateLogsTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: "SimulateLogsViewController"
        )
        
        Analytics.logEvent("simulate_logs_tapped", parameters: [
                "action_type": "button_click"
            ])
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

