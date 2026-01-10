//
//  UserDetailsViewController.swift
//  Manage Users
//
//  Created by BP-19-114-19 on 21/12/2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore
import FirebaseAnalytics

class UserDetailsViewController: UIViewController {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var roleButton: UIButton!
    @IBOutlet weak var deleteUserButton: UIButton!
    @IBOutlet weak var restoreUserButton: UIButton!
    
    var user: AppUser!
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
            configureRestoreButton()
            super.viewDidLoad()
            populateUI()
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
                    AnalyticsParameterScreenName: "UserDetails",
                    AnalyticsParameterScreenClass: "UserDetailsViewController"
                ])

                Analytics.logEvent("view_user_details", parameters: [
                    "user_id": user.id
                ])
        }
    
    private func populateUI() {
           idLabel.text = user.id
           nameLabel.text = user.fullname
           emailLabel.text = user.email
           roleLabel.text = user.userType
        phoneLabel.text = user.phone
        
        if user.userType.lowercased() == "admin" {
                roleButton.isEnabled = false
                roleButton.alpha = 0.5
            } else {
                roleButton.isEnabled = true
                roleButton.alpha = 1.0
            }
        if user.isDeleted {
            deleteUserButton.isEnabled = false
            deleteUserButton.alpha = 0.5
            deleteUserButton.setTitle("User Deleted", for: .disabled)
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
    
    

    
    @IBAction func changeRoleTapped(_ sender: UIButton) {
        guard user != nil else { return }
        
        guard user.userType.lowercased() != "admin" else {
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
        
        if let popover = alert.popoverPresentationController {
               popover.sourceView = sender
               popover.sourceRect = sender.bounds
           }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        Analytics.logEvent("change_role_tapped", parameters: [
                "action_type": "button_click"
            ])

        present(alert, animated: true)
    }
    
    private func updateRole(to newRole: String) {
        guard let user = user else { return }

        db.collection("users")
            .document(user.id)
            .updateData([
                "userType": newRole
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
                        targetUserId: user.id
                    )
        Analytics.logEvent("Role Updated", parameters: ["User":user.id])
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
        
        if let popover = alert.popoverPresentationController {
               popover.sourceView = sender
               popover.sourceRect = sender.bounds
           }
        
        Analytics.logEvent("delete_user_tapped", parameters: [
                "action_type": "button_click"
            ])

        present(alert, animated: true)
    }
    
    private func softDeleteUser(_ user: AppUser) {
        db.collection("users")
            .document(user.id)
            .updateData([
                "isDeleted": true,
            ]) { error in
                if let error = error {
                    print("❌ Delete failed:", error)
                    return
                }
                
                AuditLogger.log(
                                action: "USER_DELETED",
                                targetUserId: user.id
                            )

                self.navigationController?.popViewController(animated: true)
            }
        Analytics.logEvent("User Deleted", parameters:
                            ["Users": user.id,
                             "Deleted At": Date()])
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
        
        if let popover = alert.popoverPresentationController {
               popover.sourceView = sender
               popover.sourceRect = sender.bounds
           }

        Analytics.logEvent("restore_tapped", parameters: [
                "action_type": "button_click"
            ])
        
        present(alert, animated: true)
    }
    
    private func restoreUser(_ user: AppUser) {
        db.collection("users")
            .document(user.id)
            .updateData([
                "isDeleted": false,
            ]) { error in
                if let error = error {
                    print("❌ Restore failed:", error)
                    return
                }
                
                AuditLogger.log(
                               action: "USER_RESTORED",
                               targetUserId: user.id
                           )

                self.navigationController?.popViewController(animated: true)
            }
        Analytics.logEvent("User Restored", parameters: ["User": user.id,
                                                         "Restored At": Date()])
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
