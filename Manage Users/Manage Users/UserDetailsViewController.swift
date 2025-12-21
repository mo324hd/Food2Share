//
//  UserDetailsViewController.swift
//  Manage Users
//
//  Created by BP-19-114-19 on 21/12/2025.
//

import UIKit
import FirebaseFirestore

class UserDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var activeSwitch: UISwitch!
    
    var user: AppUser!
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
            super.viewDidLoad()
            populateUI()
        }
    
    private func populateUI() {
           nameLabel.text = user.fullName
           emailLabel.text = user.email
           ageLabel.text = String(user.age)
           roleLabel.text = user.role
           activeSwitch.isOn = user.isActive
       }
    
    @IBAction func activeSwitchChanged(_ sender: UISwitch) {
            guard let user = user else { return }

            db.collection("Users(Admin)")
                .document(user.id)
                .updateData([
                    "isActive": sender.isOn
                ]) { error in
                    if let error = error {
                        print("❌ Failed to update isActive:", error)
                        sender.isOn.toggle() // rollback UI
                    } else {
                        print("✅ User active status updated")
                    }
                }
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
