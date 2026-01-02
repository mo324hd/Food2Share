//
//  FoodListTableViewController.swift
//  Food2Share_Main
//
//  Created by BP-36-224-17 on 02/01/2026.
//

import UIKit
import FirebaseDatabase

class FoodListTableViewController: UITableViewController {
    
    var foodItems: [FoodItem] = []
    private var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Food Items"
                ref = Database.database().reference().child("food_item")
                
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                    target: self,
                                                                    action: #selector(addFoodItem))
                navigationItem.leftBarButtonItem = editButtonItem
                
                fetchFoodItems()
    }
    
    func fetchFoodItems() {
            ref.observe(.value) { snapshot in
                var items: [FoodItem] = []
                for child in snapshot.children {
                    if let snap = child as? DataSnapshot,
                       let dict = snap.value as? [String: Any],
                       let jsonData = try? JSONSerialization.data(withJSONObject: dict),
                       let item = try? JSONDecoder().decode(FoodItem.self, from: jsonData) {
                        items.append(item)
                    }
                }
                self.foodItems = items
                self.tableView.reloadData()
            }
        }
    
    // MARK: - Buttons
        @objc func addFoodItem() {
            let vc = AddFoodItemViewController()
            navigationController?.pushViewController(vc, animated: true)
        }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return foodItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
     let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell")
                 ?? UITableViewCell(style: .subtitle, reuseIdentifier: "FoodCell")
             let item = foodItems[indexPath.row]
             cell.textLabel?.text = item.name
             cell.detailTextLabel?.text = "\(item.category) • \(item.status)"
             return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     
     if editingStyle == .delete {
                 let id = foodItems[indexPath.row].id
                 ref.child(id).removeValue()
             }
        
        /*if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }*/
    }
    

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
    
    // Select for Details
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = FoodDetailViewController()
            vc.foodItem = foodItems[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
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
