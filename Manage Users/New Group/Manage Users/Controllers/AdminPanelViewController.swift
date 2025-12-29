//
//  AdminPanelViewController.swift
//  Manage Users
//
//  Created by BP-36-201-10 on 28/12/2025.
//

import UIKit

class AdminPanelViewController: UIViewController {
    
    @IBOutlet weak var manageUsersButton: UIButton!
    @IBOutlet var viewLogsButton: UIView!
    @IBOutlet weak var analyticsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Admin Panel"
        view.backgroundColor = .systemBackground
    }

    @IBAction func manageUsersTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: "UserTableViewController"
        )
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func viewLogsTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: "LogsTableViewController"
        )
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func analyticsTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: "analyticsViewController"
        )
        navigationController?.pushViewController(vc, animated: true)
    }
}

