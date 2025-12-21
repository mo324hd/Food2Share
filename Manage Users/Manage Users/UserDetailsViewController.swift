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
    @IBOutlet weak var roleButton: UIButton!
    
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
        
        if user.role.lowercased() == "admin" {
                roleButton.isEnabled = false
                roleButton.alpha = 0.5
            } else {
                roleButton.isEnabled = true
                roleButton.alpha = 1.0
            }
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
    
    @IBAction func changeRoleTapped(_ sender: UIButton) {
        guard user != nil else { return }
        
        guard user.role.lowercased() != "admin" else {
                let alert = UIAlertController(
                    title: "Action Not Allowed",
                    message: "Admin roles cannot be changed.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }

        let alert = UIAlertController(
            title: "Change Role",
            message: "Select a new role",
            preferredStyle: .actionSheet
        )

        ["Admin", "Donor", "Collector"].forEach { role in
            alert.addAction(UIAlertAction(title: role.capitalized, style: .default) { _ in
                self.updateRole(to: role)
            })
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }
    
    private func updateRole(to newRole: String) {
        guard let user = user else { return }

        db.collection("Users(Admin)")
            .document(user.id)
            .updateData([
                "role": newRole
            ]) { error in
                if let error = error {
                    print("❌ Role update failed:", error)
                } else {
                    self.roleLabel.text = newRole
                    print("✅ Role updated")
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
