//
//  UserDetailsViewController.swift
//  Manage Users
//
//  Created by BP-19-114-19 on 21/12/2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class UserDetailsViewController: UIViewController {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var activeSwitch: UISwitch!
    @IBOutlet weak var roleButton: UIButton!
    @IBOutlet weak var deleteUserButton: UIButton!
    @IBOutlet weak var restoreUserButton: UIButton!
    
    var user: AppUser!
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
            configureRestoreButton()
            super.viewDidLoad()
            populateUI()
        }
    
    private func populateUI() {
           idLabel.text = user.id
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
        
        if user.role.lowercased() == "admin" {
                activeSwitch.isEnabled = false
                activeSwitch.alpha = 0.5
            } else {
                activeSwitch.isEnabled = true
                activeSwitch.alpha = 1.0
            }
       }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func activeSwitchChanged(_ sender: UISwitch) {
        guard let user = user else { return }

        let currentUserId = Auth.auth().currentUser?.uid

        // 🔒 Prevent admin from deactivating themselves
        if user.role.lowercased() == "admin" && user.id == currentUserId {
            sender.isOn = true // rollback
            showAlert(
                title: "Action Not Allowed",
                message: "You cannot deactivate your own admin account."
            )
            return
        }

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

                    // 🧾 LOG ACTION (ADD THIS 👇)
                    let status = sender.isOn ? "activated" : "deactivated"

                    AuditLogger.log(
                        action: "USER_STATUS_CHANGED",
                        message: "Admin \(status) user \(user.id)",
                        targetUserId: user.id
                    )
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
        
        AuditLogger.log(
                        action: "ROLE_CHANGED",
                        message: "Admin changed role of \(user.id) to \(newRole)",
                        targetUserId: user.id
                    )
    }
    
    private func configureDeleteButton() {
        let currentUserId = Auth.auth().currentUser?.uid

        if user?.id == currentUserId {
            deleteUserButton.isHidden = true
        }
    }
    
    @IBAction func deleteUserTapped(_ sender: UIButton) {
        guard let user = user else { return }

        let alert = UIAlertController(
            title: "Delete User",
            message: "This action can be undone. Are you sure?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.softDeleteUser(user)
        })

        present(alert, animated: true)
    }
    
    private func softDeleteUser(_ user: AppUser) {
        db.collection("Users(Admin)")
            .document(user.id)
            .updateData([
                "isDeleted": true,
                "deletedAt": Timestamp(date: Date())
            ]) { error in
                if let error = error {
                    print("❌ Delete failed:", error)
                    return
                }
                
                AuditLogger.log(
                                action: "USER_DELETED",
                                message: "Admin deleted user \(user.id)",
                                targetUserId: user.id
                            )

                self.navigationController?.popViewController(animated: true)
            }
    }
    
    @IBAction func restoreUserTapped(_ sender: UIButton) {
        guard let user = user else { return }

        let alert = UIAlertController(
            title: "Restore User",
            message: "This will reactivate the user account.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Restore", style: .default) { _ in
            self.restoreUser(user)
        })

        present(alert, animated: true)
    }
    
    private func restoreUser(_ user: AppUser) {
        db.collection("Users(Admin)")
            .document(user.id)
            .updateData([
                "isDeleted": false,
                "deletedAt": FieldValue.delete(),
                "isActive": true
            ]) { error in
                if let error = error {
                    print("❌ Restore failed:", error)
                    return
                }
                
                AuditLogger.log(
                               action: "USER_RESTORED",
                               message: "Admin restored user \(user.id)",
                               targetUserId: user.id
                           )

                self.navigationController?.popViewController(animated: true)
            }
    }
    
    private func configureRestoreButton() {
        restoreUserButton.isHidden = !(user?.isDeleted ?? false)
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
