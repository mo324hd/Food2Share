//
//  UserTableViewController.swift
//  Admin Manage Users
//
//  Created by BP-36-201-10 on 07/12/2025.
//

import UIKit
import FirebaseCore
import FirebaseFirestore




class UserTableViewController: UITableViewController {
    
    private var listener: ListenerRegistration?
    private var showDeletedUsers = false
    
    private func showUserDetails(user: AppUser) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "UserDetailsViewController"
        ) as! UserDetailsViewController

        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private var users: [AppUser] = []
       private let db = Firestore.firestore()

       override func viewDidLoad() {
           super.viewDidLoad()
           navigationItem.rightBarButtonItem = UIBarButtonItem(
                   title: "Deleted",
                   style: .plain,
                   target: self,
                   action: #selector(toggleDeletedUsers)
               )
           listenForUsers()
           fetchUsers()
       }
    
    
    @objc private func toggleDeletedUsers() {
        showDeletedUsers.toggle()
        fetchUsers()
    }
    
    private func listenForUsers() {
        listener = db.collection("Users(Admin)")
            .addSnapshotListener { [weak self] snapshot, error in

                if let error = error {
                    print("❌ Listener error:", error)
                    return
                }

                self?.users = snapshot?.documents.compactMap {
                    AppUser(document: $0)
                } ?? []

                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
    }
    
    deinit {
            listener?.remove()  // 👈 STEP 4
        }

    private func fetchUsers() {
        db.collection("Users(Admin)")
            .order(by: "createdAt", descending: true)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("❌ Error:", error)
                    return
                }

                guard let self = self else { return }

                let allUsers = snapshot?.documents.compactMap {
                    AppUser(document: $0)
                } ?? []

              
                self.users = allUsers.filter {
                    $0.isDeleted == self.showDeletedUsers
                }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
    }
    
 

    // MARK: - Table view data source
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! CustomTableViewCell

        let user = users[indexPath.row]
        
        
        

        cell.nameLabel.text = user.fullName
        cell.emailLabel.text = user.email
        cell.roleLabel.text = user.role
        
        cell.onViewTapped = { [weak self] in
                self?.showUserDetails(user: user)
            }
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
