//
//  UserTableViewController.swift
//  Admin Manage Users
//
//  Created by BP-36-201-10 on 07/12/2025.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    let usersList: [User] = [
        User(id: 1, name: "Ahmed Ali", email: "ahmed1@email.com", age: 22, isActive: true, role: "donor"),
        User(id: 2, name: "Sara Hassan", email: "sara2@email.com", age: 21, isActive: true, role: "collector"),
        User(id: 3, name: "Omar Khalid", email: "omar3@email.com", age: 25, isActive: false, role: "donor"),
        User(id: 4, name: "Fatima Noor", email: "fatima4@email.com", age: 23, isActive: true, role: "collector"),
        User(id: 5, name: "Yusuf Adel", email: "yusuf5@email.com", age: 27, isActive: false, role: "admin"),
        User(id: 6, name: "Aisha Karim", email: "aisha6@email.com", age: 20, isActive: true, role: "donor"),
        User(id: 7, name: "Hassan Saleh", email: "hassan7@email.com", age: 24, isActive: true, role: "collector"),
        User(id: 8, name: "Mariam Zaid", email: "mariam8@email.com", age: 22, isActive: false, role: "donor"),
        User(id: 9, name: "Khalid Rahman", email: "khalid9@email.com", age: 29, isActive: true, role: "admin"),
        User(id: 10, name: "Noor Ahmed", email: "noor10@email.com", age: 19, isActive: true, role: "donor"),

        User(id: 11, name: "Tariq Mansoor", email: "tariq11@email.com", age: 26, isActive: false, role: "collector"),
        User(id: 12, name: "Laila Yusuf", email: "laila12@email.com", age: 23, isActive: true, role: "donor"),
        User(id: 13, name: "Salman Rafi", email: "salman13@email.com", age: 28, isActive: true, role: "admin"),
        User(id: 14, name: "Rania Adel", email: "rania14@email.com", age: 21, isActive: false, role: "collector"),
        User(id: 15, name: "Bilal Hamza", email: "bilal15@email.com", age: 24, isActive: true, role: "donor"),
        User(id: 16, name: "Huda Nasser", email: "huda16@email.com", age: 22, isActive: true, role: "collector"),
        User(id: 17, name: "Zain Farooq", email: "zain17@email.com", age: 27, isActive: false, role: "donor"),
        User(id: 18, name: "Reem Saeed", email: "reem18@email.com", age: 20, isActive: true, role: "collector"),
        User(id: 19, name: "Adnan Qasim", email: "adnan19@email.com", age: 30, isActive: false, role: "admin"),
        User(id: 20, name: "Sana Fawaz", email: "sana20@email.com", age: 24, isActive: true, role: "donor")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usersList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! CustomTableViewCell

        let user = usersList[indexPath.row]
        
        print(user)

        cell.nameLabel.text = user.name
        cell.emailLabel.text = user.email
        cell.roleLabel.text = user.role
        

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
